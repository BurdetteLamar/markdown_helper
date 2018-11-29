require 'pathname'
require 'markdown_helper/version'

class MarkdownHelper

  class MarkdownHelperError < RuntimeError; end
  class CircularIncludeError < MarkdownHelperError; end
  class UnreadableInputError < MarkdownHelperError; end
  class TocHeadingsError < MarkdownHelperError; end
  class OptionError < MarkdownHelperError; end
  class EnvironmentError < MarkdownHelperError; end

  INCLUDE_REGEXP = /^@\[([^\[]+)\]\(([^)]+)\)$/

  attr_accessor :pristine

  def initialize(options = {})
    # Confirm that we're in a git project.
    # This is necessary so that we can prune file paths in the tests,
    # which otherwise would fail because of differing installation directories.
    # It also allows pruned paths to be used in the inserted comments (when not pristine).
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

  def include(template_file_path, markdown_file_path)
    send(:generate_file, template_file_path, markdown_file_path, __method__) do |input_lines, output_lines|
      send(:include_files, template_file_path, input_lines, output_lines, Inclusions.new)
    end
  end

  def create_page_toc(markdown_file_path, toc_file_path)
    message = <<EOT
Method create_page_toc is deprecated.
Please use method include with embedded :page_toc treatment.
See https://github.com/BurdetteLamar/markdown_helper/blob/master/markdown/use_cases/include_files/include_page_toc/use_case.md#include-page-toc.
EOT
    warn(message)
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
      remove_regexp = /[\#\(\)\[\]\{\}\.\?\+\*\`\"]+/
      to_hyphen_regexp = /\W+/
      anchor = title.
          gsub(remove_regexp, '').
          gsub(to_hyphen_regexp, '-').
          downcase
      "[#{title}](##{anchor})"
    end

  end

  def self.comment(text)
    "<!--#{text}-->\n"
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
    first_heading_level = nil
    input_lines.each do |input_line|
      line = input_line.chomp
      heading = Heading.parse(line)
      next unless heading
      first_heading_level ||= heading.level
      indentation = '  ' * (heading.level - first_heading_level)
      output_line = "#{indentation}- #{heading.link}"
      output_lines.push("#{output_line}\n")
    end
  end

  def include_files(includer_file_path, input_lines, output_lines, inclusions)
    page_toc_inclusion = nil
    input_lines.each_with_index do |input_line, line_index|
      match_data = input_line.match(INCLUDE_REGEXP)
      unless match_data
        output_lines.push(input_line)
        next
      end
      treatment = match_data[1]
      cited_includee_file_path = match_data[2]
      new_inclusion = Inclusion.new(
          input_line.chomp,
          includer_file_path,
          line_index + 1,
          cited_includee_file_path,
          treatment
      )
      if treatment == ':page_toc'
        page_toc_inclusion = new_inclusion
        page_toc_inclusion.page_toc_title = match_data[2]
        page_toc_inclusion.page_toc_line = input_line
        output_lines.push(input_line)
        next
      end
      inclusions.include(
          new_inclusion,
          output_lines,
          self
      )
    end
    return if page_toc_inclusion.nil?
    toc_lines = [
        page_toc_inclusion.page_toc_title + "\n",
        '',
    ]
    page_toc_index =  output_lines.index(page_toc_inclusion.page_toc_line)
    lines_to_scan = output_lines[page_toc_index + 1..-1]
    _create_page_toc(lines_to_scan, toc_lines)
    output_lines.delete_at(page_toc_index)
    output_lines.insert(page_toc_index, *toc_lines)
  end

  def self.git_clone_dir_path
    git_dir = `git rev-parse --show-toplevel`.chomp
    unless $?.success?
      message = <<EOT

Markdown helper must run inside a .git project.
That is, the working directory one of its parents must be a .git directory.
EOT
      raise RuntimeError.new(message)
    end
    git_dir
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
      new_inclusion,
      output_lines,
      markdown_helper
    )
      treatment = case new_inclusion.treatment
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
                      new_inclusion.treatment
                  end
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
        message = "Warning:  Included file has no trailing newline: #{new_inclusion.cited_includee_file_path}"
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
          file_name_line = format("```%s```:\n", File.basename(new_inclusion.cited_includee_file_path))
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

  end

  class Inclusion

    LINE_COUNT = 5

    attr_accessor \
      :includer_file_path,
      :includer_line_number,
      :include_description,
      :absolute_includee_file_path,
      :cited_includee_file_path,
      :treatment,
      :page_toc_title,
      :page_toc_line

    def initialize(
        include_description,
        includer_file_path,
        includer_line_number,
        cited_includee_file_path,
        treatment
    )
      self.include_description = include_description
      self.includer_file_path = includer_file_path
      self.includer_line_number = includer_line_number
      self.cited_includee_file_path = cited_includee_file_path
      self.absolute_includee_file_path = absolute_includee_file_path
      self.treatment = treatment
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

  end

end

