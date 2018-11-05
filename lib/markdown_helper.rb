require 'pathname'
require 'markdown_helper/version'

# Helper class for working with GitHub markdown.
#  Supports file inclusion.
#
# @author Burdette Lamar
class MarkdownHelper

  class MarkdownHelperError < RuntimeError; end
  class CircularIncludeError < MarkdownHelperError; end
  class UnreadableInputError < MarkdownHelperError; end
  class TocHeadingsError < MarkdownHelperError; end
  class OptionError < MarkdownHelperError; end
  class EnvironmentError < MarkdownHelperError; end

  INCLUDE_REGEXP = /^@\[([^\[]+)\]\(([^)]+)\)$/

  attr_accessor :pristine, :page_toc_title, :page_toc_line

  def initialize(options = {})
    # Confirm that we're in a git project.
    MarkdownHelper.git_clone_dir_path
    default_options = {
        :pristine => false,
    }
    merged_options = default_options.merge(options)
    merged_options.each_pair do |method, value|
      unless self.respond_to?(method)
        raise OptionError.new("Unknown option: #{method}")
      end
      setter_method = "#{method}="
      send(setter_method, value)
      merged_options.delete(method)
    end
  end

  # Merges external files into markdown text.
  # @param template_file_path [String] the path to the input template markdown file, usually containing include pragmas.
  # @param markdown_file_path [String] the path to the output merged markdown file.
  # @return [String] the resulting markdown text.
  #
  # @example pragma to include text as a highlighted code block.
  #   @[ruby](foo.rb)
  #
  # @example pragma to include text as a plain code block.
  #   @[:code_block](foo.xyz)
  #
  # @example pragma to include text markdown, to be rendered as markdown.
  #   @[:markdown](foo.md)
  def include(template_file_path, markdown_file_path)
    send(:generate_file, template_file_path, markdown_file_path, __method__) do |input_lines, output_lines|
      send(:include_files, template_file_path, input_lines, output_lines, Inclusions.new)
    end
  end

  def create_page_toc(markdown_file_path, toc_file_path)
    send(:generate_file, markdown_file_path, toc_file_path, __method__) do |input_lines, output_lines|
      send(:_create_page_toc, input_lines, output_lines)
    end
  end

  private

  class Heading

    attr_accessor :level, :title

    def initialize(level, title)
      self.level = level
      self.title = title
    end

    def self.parse(line)
      # Four leading spaces not allowed (but three are allowed).
      return nil if line.start_with?(' ' * 4)
      stripped_line = line.sub(/^ */, '')
      # Now must begin with hash marks and space.
      return nil unless stripped_line.match(/^#+ /)
      hash_marks, title = stripped_line.split(' ', 2)
      level = hash_marks.size
      # Seventh level heading not allowed.
      return nil if level > 6
      self.new(level, title)
    end

    def link
      anchor = title.gsub(/\W+/, '-').downcase
      "[#{title}](##{anchor})"
    end

  end

  def self.comment(text)
    "<!--#{text}-->\n"
  end

  def repo_user_and_name
    repo_user = ENV['REPO_USER']
    repo_name = ENV['REPO_NAME']
    unless repo_user and repo_name
      message = 'ENV values for both REPO_USER and REPO_NAME must be defined.'
      raise EnvironmentError.new(message)
    end
    [repo_user, repo_name]
  end

  def generate_file(template_file_path, markdown_file_path, method)
    unless File.readable?(template_file_path)
      message = [
          Inclusions::UNREADABLE_INPUT_EXCEPTION_LABEL,
          template_file_path.inspect,
      ].join("\n")
      raise UnreadableInputError.new(message)
    end
    output_lines = []
    File.open(template_file_path, 'r') do |template_file|
      template_path_in_project = MarkdownHelper.path_in_project(template_file_path)
      output_lines.push(MarkdownHelper.comment(" >>>>>> BEGIN GENERATED FILE (#{method.to_s}): SOURCE #{template_path_in_project} ")) unless pristine
      input_lines = template_file.readlines
      yield input_lines, output_lines
      output_lines.push(MarkdownHelper.comment(" <<<<<< END GENERATED FILE (#{method.to_s}): SOURCE #{template_path_in_project} ")) unless pristine
    end
    File.open(markdown_file_path, 'w') do |file|
      output_lines.each do |line|
        file.write(line)
      end
    end
  end

  def _create_page_toc(input_lines, output_lines)
    input_lines.each do |input_line|
      line = input_line.chomp
      heading = Heading.parse(line)
      next unless heading
      indentation = '  ' * heading.level
      output_line = "#{indentation}- #{heading.link}"
      output_lines.push("#{output_line}\n")
    end
  end

  def include_files(includer_file_path, input_lines, output_lines, inclusions)

    input_lines.each_with_index do |input_line, line_index|
      match_data = input_line.match(INCLUDE_REGEXP)
      unless match_data
        output_lines.push(input_line)
        next
      end
      treatment = match_data[1]
      if treatment == ':page_toc'
        self.page_toc_title = match_data[2]
        self.page_toc_line = input_line
        output_lines.push(input_line)
        next
      end
      cited_includee_file_path = match_data[2]
      inclusions.include(
          input_line.chomp,
          includer_file_path,
          line_index + 1,
          cited_includee_file_path,
          treatment,
          output_lines,
          self
      )
    end
    return if self.page_toc_title.nil?
    toc_lines = [
        self.page_toc_title + "\n",
        '',
    ]
    page_toc_index =  output_lines.index(self.page_toc_line)
    lines_to_scan = input_lines[page_toc_index + 1..-1]
    _create_page_toc(input_lines, toc_lines)
    output_lines.delete_at(page_toc_index)
    output_lines.insert(page_toc_index, *toc_lines)
  end

  def self.git_clone_dir_path
    git_dir = `git rev-parse --git-dir`.chomp
    unless $?.success?
      message = <<EOT

Markdown helper must run inside a .git project.
That is, the working directory one of its parents must be a .git directory.
EOT
      raise RuntimeError.new(message)
    end
    if git_dir == '.git'
      path = `pwd`.chomp
    else
      path = File.dirname(git_dir).chomp
    end
    realpath = Pathname.new(path.sub(%r|/c/|, 'C:/')).realpath
    realpath.to_s
  end

  def self.path_in_project(path)
    path.sub(MarkdownHelper.git_clone_dir_path + '/', '')
  end

  class Inclusions

    attr_accessor :inclusions

    def initialize
      self.inclusions = []
    end

    def include(
        include_description,
        includer_file_path,
        includer_line_number,
        cited_includee_file_path,
        treatment,
        output_lines,
        markdown_helper
    )
      treatment = case treatment
                    when ':code_block'
                      :code_block
                    when ':markdown'
                      :markdown
                    when ':verbatim'
                      message = "Treatment ':verbatim' is deprecated; please use treatment ':markdown'."
                      warn(message)
                      :markdown
                    when ':comment'
                      :comment
                    when ':pre'
                      :pre
                    else
                      treatment
                  end
      new_inclusion = Inclusion.new(
          include_description,
          includer_file_path,
          includer_line_number,
          cited_includee_file_path
      )
      if treatment == :markdown
        check_circularity(new_inclusion)
      end
      includee_path_in_project = MarkdownHelper.path_in_project(new_inclusion.absolute_includee_file_path)
      output_lines.push(MarkdownHelper.comment(" >>>>>> BEGIN INCLUDED FILE (#{treatment}): SOURCE #{includee_path_in_project} ")) unless markdown_helper.pristine
      begin
        include_lines = File.readlines(new_inclusion.absolute_includee_file_path)
      rescue => e
        inclusions.push(new_inclusion)
        message = [
            MISSING_INCLUDEE_EXCEPTION_LABEL,
            backtrace_inclusions,
        ].join("\n")
        e = UnreadableInputError.new(message)
        e.set_backtrace([])
        raise e
      end
      last_line = include_lines.last
      unless last_line && last_line.match("\n")
        message = "Warning:  Included file has no trailing newline: #{cited_includee_file_path}"
        warn(message)
      end
      case treatment
        when :markdown
          # Pass through unadorned, but honor any nested includes.
          inclusions.push(new_inclusion)
          markdown_helper.send(:include_files, new_inclusion.absolute_includee_file_path, include_lines, output_lines, self)
          inclusions.pop
        when :comment
          output_lines.push(MarkdownHelper.comment(include_lines.join('')))
        when :pre
          output_lines.push("<pre>\n")
          output_lines.push(include_lines.join(''))
          output_lines.push("</pre>\n")
        else
          # Use the file name as a label.
          file_name_line = format("```%s```:\n", File.basename(cited_includee_file_path))
          output_lines.push(file_name_line)
          # Put into code block.
          language = treatment == :code_block ? '' : treatment
          output_lines.push("```#{language}\n")
          output_lines.push(*include_lines)
          output_lines.push("```\n")
      end
      output_lines.push(MarkdownHelper.comment(" <<<<<< END INCLUDED FILE (#{treatment}): SOURCE #{includee_path_in_project} ")) unless markdown_helper.pristine
    end

    CIRCULAR_EXCEPTION_LABEL = 'Includes are circular:'
    UNREADABLE_INPUT_EXCEPTION_LABEL = 'Could not read input file.'
    UNWRITABLE_OUTPUT_EXCEPTION_LABEL = 'Could not write output file.'
    MISSING_INCLUDEE_EXCEPTION_LABEL = 'Could not read include file,'
    LEVEL_LABEL = '    Level'
    BACKTRACE_LABEL = '  Backtrace (innermost include first):'

    def check_circularity(new_inclusion)
      previous_inclusions = inclusions.collect {|x| x.real_includee_file_path}
      previously_included = previous_inclusions.include?(new_inclusion.real_includee_file_path)
      if previously_included
        inclusions.push(new_inclusion)
        message = [
            CIRCULAR_EXCEPTION_LABEL,
            backtrace_inclusions,
            ].join("\n")
        e = MarkdownHelper::CircularIncludeError.new(message)
        e.set_backtrace([])
        raise e
      end
    end

    def backtrace_inclusions
      lines = [BACKTRACE_LABEL]
      inclusions.reverse.each_with_index do |inclusion, i|
        lines.push("#{LEVEL_LABEL} #{i}:")
        level_lines = inclusion.to_lines(indentation_level = 3)
        lines.push(*level_lines)
      end
      lines.join("\n")
    end

    def self.assert_io_exception(test, expected_exception_class, expected_label, expected_file_path, e)
      test.assert_kind_of(expected_exception_class, e)
      lines = e.message.split("\n")
      actual_label = lines.shift
      test.assert_equal(expected_label, actual_label)
      actual_file_path = lines.shift
      test.assert_equal(expected_file_path.inspect, actual_file_path)
    end

    def self.assert_inclusion_exception(test, expected_exception_class, exception_label, expected_inclusions, e)
      test.assert_kind_of(expected_exception_class, e)
      lines = e.message.split("\n")
      label_line = lines.shift
      test.assert_equal(exception_label, label_line)
      backtrace_line = lines.shift
      test.assert_equal(BACKTRACE_LABEL, backtrace_line)
      level_line_count = 1 + Inclusion::LINE_COUNT
      level_count = lines.size / level_line_count
      # Backtrace levels are innermost first, opposite of inclusions.
      reversed_inclusions = expected_inclusions.inclusions.reverse
      (0...level_count).each do |level_index|
        level_line = lines.shift
        inclusion_lines = lines.shift(Inclusion::LINE_COUNT)
        test.assert_equal("#{LEVEL_LABEL} #{level_index}:", level_line)
        expected_inclusion = reversed_inclusions[level_index]
        expected_inclusion.assert_lines(test, level_index, inclusion_lines)
      end
    end

    def self.assert_circular_exception(test, expected_inclusions, e)
      self.assert_inclusion_exception(
              test,
              CircularIncludeError,
              CIRCULAR_EXCEPTION_LABEL,
              expected_inclusions,
              e
      )
    end

    def self.assert_includee_missing_exception(test, expected_inclusions, e)
      self.assert_inclusion_exception(
          test,
          Exception,
          MISSING_INCLUDEE_EXCEPTION_LABEL,
          expected_inclusions,
          e
      )
    end

    def self.assert_template_exception(test, expected_file_path, e)
      self.assert_io_exception(
          test,
          Exception,
          UNREADABLE_INPUT_EXCEPTION_LABEL,
          expected_file_path,
          e
      )
    end

  end

  class Inclusion

    LINE_COUNT = 5

    attr_accessor \
      :includer_file_path,
      :includer_line_number,
      :include_description,
      :absolute_includee_file_path,
      :cited_includee_file_path

    def initialize(
        include_description,
        includer_file_path,
        includer_line_number,
        cited_includee_file_path
    )
      self.include_description = include_description
      self.includer_file_path = includer_file_path
      self.includer_line_number = includer_line_number
      self.cited_includee_file_path = cited_includee_file_path
      self.absolute_includee_file_path = absolute_includee_file_path
      self.absolute_includee_file_path = File.absolute_path(File.join(
          File.dirname(includer_file_path),
          cited_includee_file_path,
      ))
    end

    def real_includee_file_path
      # Would raise exception unless exists.
      return nil unless File.exist?(absolute_includee_file_path)
      Pathname.new(absolute_includee_file_path).realpath.to_s
    end

    def indentation(level)
      '  ' * level
    end

    def to_lines(indentation_level)
      relative_inluder_file_path = MarkdownHelper.path_in_project(includer_file_path)
      relative_inludee_file_path = MarkdownHelper.path_in_project(absolute_includee_file_path)
       text = <<EOT
#{indentation(indentation_level)}Includer:
#{indentation(indentation_level+1)}Location: #{relative_inluder_file_path}:#{includer_line_number}
#{indentation(indentation_level+1)}Include description: #{include_description}
#{indentation(indentation_level)}Includee:
#{indentation(indentation_level+1)}File path: #{relative_inludee_file_path}
EOT
      text.split("\n")
    end

    def assert_lines(test, level_index, actual_lines)
      level_label = "Level #{level_index}:"
      # Includer label.
      includee_label = actual_lines.shift
      test.assert_match(/^\s*Includer:$/, includee_label, level_label)
      # Includer locatioin.
      location = actual_lines.shift
      message = "#{level_label} includer location"
      test.assert_match(/^\s*Location:/, location, message)
      includer_realpath =  Pathname.new(includer_file_path).realpath.to_s
      relative_path = MarkdownHelper.path_in_project(includer_realpath)
      r = Regexp.new(Regexp.escape("#{relative_path}:#{includer_line_number}") + '$')
      test.assert_match(r, location, message)
      # Include description.
      description = actual_lines.shift
      message = "#{level_label} include description"
      test.assert_match(/^\s*Include description:/, description, message)
      r = Regexp.new(Regexp.escape("#{include_description}") + '$')
      test.assert_match(r, description, message)
      # Includee label.
      includee_label = actual_lines.shift
      test.assert_match(/^\s*Includee:$/, includee_label, level_label)
      # Includee file path.
      includee_file_path = actual_lines.shift
      message = "#{level_label} includee cited file path"
      test.assert_match(/^\s*File path:/, includee_file_path, message)
      relative_path = MarkdownHelper.path_in_project(absolute_includee_file_path)
      r = Regexp.new(Regexp.escape("#{relative_path}") + '$')
      test.assert_match(r, includee_file_path, message)
    end

  end

end

