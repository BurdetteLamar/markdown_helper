require 'pathname'

require 'markdown_helper/version'

class MarkdownHelper

  class MarkdownHelperError < RuntimeError; end
  class OptionError < MarkdownHelperError; end
  class MultiplePageTocError < MarkdownHelperError; end
  class InvalidTocTitleError < MarkdownHelperError; end
  class UnreadableInputError < MarkdownHelperError; end
  class CircularIncludeError < MarkdownHelperError; end

  INCLUDE_REGEXP = /^@\[([^\[]+)\]\(([^)]+)\)$/
  INCLUDE_MARKDOWN_REGEXP = /^@\[:markdown\]\(([^)]+)\)$/

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
    @inclusions = []
  end

  def include(template_file_path, markdown_file_path)
    send(:generate_file, template_file_path, markdown_file_path) do |output_lines|
      Dir.chdir(File.dirname(template_file_path)) do
        markdown_lines = include_markdown(template_file_path)
        markdown_lines = include_page_toc(markdown_lines)
        include_all(template_file_path, markdown_lines, output_lines)
      end
    end
  end

  private

  def generate_file(template_file_path, markdown_file_path)
    unless File.readable?(template_file_path)
      message = [
          'Could not read input file.',
          template_file_path.inspect,
      ].join("\n")
      raise UnreadableInputError.new(message)
    end
    template_path_in_project = MarkdownHelper.path_in_project(template_file_path)
    output_lines = []
    yield output_lines
    unless pristine
      output_lines.unshift(MarkdownHelper.comment(" >>>>>> BEGIN GENERATED FILE (include): SOURCE #{template_path_in_project} "))
      output_lines.push(MarkdownHelper.comment(" <<<<<< END GENERATED FILE (include): SOURCE #{template_path_in_project} "))
    end
    output_lines.push('')
    output = output_lines.join("\n")
    File.write(markdown_file_path, output)
  end

  def include_markdown(template_file_path)
    Dir.chdir(File.dirname(template_file_path)) do
      markdown_lines = []
      template_lines = File.readlines(template_file_path)
      template_lines.each_with_index do |template_line, i|
        template_line.chomp!
        treatment, includee_file_path = *parse_include(template_line)
        if treatment.nil?
          markdown_lines.push(template_line)
          next
        end
        if treatment == ':page_toc'
          markdown_lines.push(template_line)
          next
        end
        inclusion = Inclusion.new(
            template_file_path,
            template_line,
            i,
            treatment,
            includee_file_path
            )
        treatment.sub!(/^:/, '')
        case treatment
        when 'markdown'
          check_circularity(inclusion)
          @inclusions.push(inclusion)
          includee_lines = include_markdown(includee_file_path)
          markdown_lines.concat(includee_lines)
        when 'comment'
          text = File.read(includee_file_path)
          markdown_lines.push(MarkdownHelper.comment(text))
          @inclusions.push(inclusion)
        when 'pre'
          text = File.read(includee_file_path)
          markdown_lines.push(MarkdownHelper.pre(text))
          @inclusions.push(inclusion)
        else
          markdown_lines.push(template_line)
          next
        end
        @inclusions.pop
        add_inclusion_comments(treatment, includee_file_path, markdown_lines)
      end
      markdown_lines
    end
  end

  def include_page_toc(template_lines)
    toc_line_index = nil
    toc_title = nil
    template_lines.each_with_index do |template_line, i|
      match_data = template_line.match(INCLUDE_REGEXP)
      next unless match_data
      treatment = match_data[1]
      next unless treatment == ':page_toc'
      unless toc_line_index.nil?
        message = 'Multiple page TOC not allowed'
        raise MultiplePageTocError.new(message)
      end
      toc_line_index = i
      toc_title = match_data[2]
      title_regexp = /^\#{1,6}\s/
      unless toc_title.match(title_regexp)
        message = "TOC title must be a valid markdown header, not #{toc_title}"
        raise InvalidTocTitleError.new(message)
      end
    end
    return template_lines unless toc_line_index
    toc_lines = [toc_title]
    first_heading_level = nil
    template_lines.each_with_index do |input_line, i|
      next if i < toc_line_index
      line = input_line.chomp
      heading = Heading.parse(line)
      next unless heading
      first_heading_level ||= heading.level
      indentation = '  ' * (heading.level - first_heading_level)
      toc_line = "#{indentation}- #{heading.link}"
      toc_lines.push(toc_line)
    end
    template_lines.delete_at(toc_line_index)
    template_lines.insert(toc_line_index, *toc_lines)
    template_lines
  end

  def include_all(template_file_path, template_lines, output_lines)
    template_lines.each_with_index do |template_line, i|
      treatment, includee_file_path = *parse_include(template_line)
      if treatment.nil?
        output_lines.push(template_line)
        next
      end
      inclusion = Inclusion.new(
          template_file_path,
          template_line,
          i,
          treatment,
          includee_file_path
      )
      @inclusions.push(inclusion)
      file_marker = format('```%s```:', File.basename(includee_file_path))
      output_lines.push(file_marker)
      includee_lines = include_markdown(includee_file_path)
      begin_backticks = '```'
      begin_backticks += treatment unless treatment.start_with?(':')
      output_lines.push(begin_backticks)
      output_lines.concat(includee_lines)
      output_lines.push('```')
      treatment.sub!(':', '')
      add_inclusion_comments(treatment, includee_file_path, output_lines)
    end
  end

  def add_inclusion_comments(treatment, includee_file_path, lines)
    path_in_project = MarkdownHelper.path_in_project(includee_file_path)
    unless pristine
      comment = format(' >>>>>> BEGIN INCLUDED FILE (%s): SOURCE %s ', treatment, path_in_project)
      lines.unshift(MarkdownHelper.comment(comment))
      comment = format(' <<<<<< END INCLUDED FILE (%s): SOURCE %s ', treatment, path_in_project)
      lines.push(MarkdownHelper.comment(comment))
    end
  end

    def parse_include(line)
    match_data = line.match(INCLUDE_REGEXP)
    return [nil, nil] unless match_data
    treatment = match_data[1]
    includee_file_path = match_data[2]
    [treatment, includee_file_path]
  end

  def self.path_in_project(file_path)
    abs_path = File.absolute_path(file_path)
    abs_path.sub(self.git_clone_dir_path + '/', '')
  end

  def self.comment(text)
    "<!--#{text}-->"
  end

  def self.pre(text)
    "<pre>\n#{text}</pre>"
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
      remove_regexp = /[\#\(\)\[\]\{\}\.\?\+\*\`\"\']+/
      to_hyphen_regexp = /\W+/
      anchor = title.
          gsub(remove_regexp, '').
          gsub(to_hyphen_regexp, '-').
          downcase
      "[#{title}](##{anchor})"
    end

  end

  def check_circularity(inclusion)
    included_file_paths = @inclusions.collect { |x| x.includee_real_file_path}
    previously_included = included_file_paths.include?(inclusion.includee_real_file_path)
    if previously_included
      @inclusions.push(inclusion)
      message = [
          'Includes are circular:',
          backtrace_inclusions,
      ].join("\n")
      e = MarkdownHelper::CircularIncludeError.new(message)
      e.set_backtrace([])
      raise e
    end
  end

  def backtrace_inclusions
    lines = ['  Backtrace (innermost include first):']
    @inclusions.reverse.each_with_index do |inclusion, i|
      lines.push("#{'    Level'} #{i}:")
      level_lines = inclusion.to_lines(indentation_level = 3)
      lines.push(*level_lines)
    end
    lines.join("\n")
  end

  class Inclusion

    attr_accessor \
      :includer_file_path,
      :includer_absolute_file_path,
      :includer_real_file_path,
      :include_pragma,
      :treatment,
      :includer_line_number,
      :cited_includee_file_path,
      :includee_absolute_file_path,
      :includee_real_file_path

    def initialize(
        includer_file_path,
        include_pragma,
        includer_line_number,
        treatment,
        cited_includee_file_path
        )
      self.includer_file_path = includer_file_path
      self.include_pragma = include_pragma
      self.includer_line_number = includer_line_number
      self.cited_includee_file_path = cited_includee_file_path
      self.treatment = treatment
      self.includee_absolute_file_path = File.absolute_path(File.join(
          File.dirname(includer_file_path),
          cited_includee_file_path,
      ))
      self.includer_absolute_file_path = File.absolute_path(includer_file_path)
      self.includer_real_file_path = Pathname.new(self.includer_absolute_file_path).realpath.to_s
      self.includee_real_file_path = Pathname.new(self.includee_absolute_file_path).realpath.to_s
    end

    def real_includee_file_path
      # Would raise exception unless exists.
      return nil unless File.exist?(includee_absolute_file_path)
      Pathname.new(includee_absolute_file_path).realpath.to_s
    end

    def indentation(level)
      '  ' * level
    end

    def to_lines(indentation_level)
      relative_inluder_file_path = MarkdownHelper.path_in_project(includer_file_path)
      relative_inludee_file_path = MarkdownHelper.path_in_project(includee_absolute_file_path)
       text = <<EOT
#{indentation(indentation_level)}Includer:
#{indentation(indentation_level+1)}Location: #{relative_inluder_file_path}:#{includer_line_number}
#{indentation(indentation_level+1)}Include description: #{include_pragma}
#{indentation(indentation_level)}Includee:
#{indentation(indentation_level+1)}File path: #{relative_inludee_file_path}
EOT
      text.split("\n")
    end

  end

end

# require 'pathname'
# require 'markdown_helper/version'
#
# class MarkdownHelper
#
#   class MarkdownHelperError < RuntimeError; end
#   class CircularIncludeError < MarkdownHelperError; end
#   class UnreadableInputError < MarkdownHelperError; end
#   class TocHeadingsError < MarkdownHelperError; end
#   class OptionError < MarkdownHelperError; end
#   class EnvironmentError < MarkdownHelperError; end
#   class InvalidTocTitleError < MarkdownHelperError; end
#   class MisplacedPageTocError < MarkdownHelperError; end
#
#   INCLUDE_REGEXP = /^@\[([^\[]+)\]\(([^)]+)\)$/
#
#   attr_accessor :pristine
#
#   def initialize(options = {})
#     # Confirm that we're in a git project.
#     # This is necessary so that we can prune file paths in the tests,
#     # which otherwise would fail because of differing installation directories.
#     # It also allows pruned paths to be used in the inserted comments (when not pristine).
#     MarkdownHelper.git_clone_dir_path
#     default_options = {
#         :pristine => false,
#     }
#     merged_options = default_options.merge(options)
#     merged_options.each_pair do |method, value|
#       unless self.respond_to?(method)
#         raise OptionError.new("Unknown option: #{method}")
#       end
#       setter_method = "#{method}="
#       send(setter_method, value)
#       merged_options.delete(method)
#     end
#   end
#
#   def include(template_file_path, markdown_file_path)
#     send(:generate_file, template_file_path, markdown_file_path, __method__) do |input_lines, output_lines|
#       send(:include_files, template_file_path, input_lines, output_lines, Inclusions.new)
#     end
#   end
#
#   private
#
#   class Heading
#
#     attr_accessor :level, :title
#
#     def initialize(level, title)
#       self.level = level
#       self.title = title
#     end
#
#     def self.parse(line)
#       # Four leading spaces not allowed (but three are allowed).
#       return nil if line.start_with?(' ' * 4)
#       stripped_line = line.sub(/^ */, '')
#       # Now must begin with hash marks and space.
#       return nil unless stripped_line.match(/^#+ /)
#       hash_marks, title = stripped_line.split(' ', 2)
#       level = hash_marks.size
#       # Seventh level heading not allowed.
#       return nil if level > 6
#       self.new(level, title)
#     end
#
#
#     def link
#       remove_regexp = /[\#\(\)\[\]\{\}\.\?\+\*\`\"\']+/
#       to_hyphen_regexp = /\W+/
#       anchor = title.
#           gsub(remove_regexp, '').
#           gsub(to_hyphen_regexp, '-').
#           downcase
#       "[#{title}](##{anchor})"
#     end
#
#   end
#
#   def self.comment(text)
#     "<!--#{text}-->\n"
#   end
#
#   def generate_file(template_file_path, markdown_file_path, method)
#     unless File.readable?(template_file_path)
#       message = [
#           Inclusions::UNREADABLE_INPUT_EXCEPTION_LABEL,
#           template_file_path.inspect,
#       ].join("\n")
#       raise UnreadableInputError.new(message)
#     end
#     output_lines = []
#     File.open(template_file_path, 'r') do |template_file|
#       template_path_in_project = MarkdownHelper.path_in_project(template_file_path)
#       output_lines.push(MarkdownHelper.comment(" >>>>>> BEGIN GENERATED FILE (#{method.to_s}): SOURCE #{template_path_in_project} ")) unless pristine
#       input_lines = template_file.readlines
#       yield input_lines, output_lines
#       output_lines.push(MarkdownHelper.comment(" <<<<<< END GENERATED FILE (#{method.to_s}): SOURCE #{template_path_in_project} ")) unless pristine
#     end
#     File.open(markdown_file_path, 'w') do |file|
#       output_lines.each do |line|
#         file.write(line)
#       end
#     end
#   end
#
#   def create_page_toc(input_lines, output_lines)
#     first_heading_level = nil
#     input_lines.each do |input_line|
#       line = input_line.chomp
#       heading = Heading.parse(line)
#       next unless heading
#       first_heading_level ||= heading.level
#       indentation = '  ' * (heading.level - first_heading_level)
#       output_line = "#{indentation}- #{heading.link}"
#       output_lines.push("#{output_line}\n")
#     end
#   end
#
#   def include_files(includer_file_path, input_lines, output_lines, inclusions)
#     markdown_lines = []
#     page_toc_inclusion = nil
#     input_lines.each_with_index do |input_line, line_index|
#       match_data = input_line.match(INCLUDE_REGEXP)
#       unless match_data
#         markdown_lines.push(input_line)
#         next
#       end
#       treatment = match_data[1]
#       cited_includee_file_path = match_data[2]
#       new_inclusion = Inclusion.new(
#           input_line.chomp,
#           includer_file_path,
#           line_index + 1,
#           cited_includee_file_path,
#           treatment
#       )
#       case treatment
#       when ':markdown'
#         inclusions.include(
#             new_inclusion,
#             markdown_lines,
#             self
#         )
#       when ':page_toc'
#         unless inclusions.inclusions.size == 0
#           message = 'Page TOC must be in outermost markdown file.'
#           raise MisplacedPageTocError.new(message)
#         end
#         unless page_toc_inclusion.nil?
#           message = 'Only one page TOC allowed.'
#           raise MultiplePageTocError.new(message)
#         end
#         page_toc_inclusion = new_inclusion
#         toc_title = match_data[2]
#         title_regexp = /^\#{1,6}\s/
#         unless toc_title.match(title_regexp)
#           message = "TOC title must be a valid markdown header, not #{toc_title}"
#           raise InvalidTocTitleError.new(message)
#         end
#         page_toc_inclusion.page_toc_title = toc_title
#         page_toc_inclusion.page_toc_line = input_line
#         markdown_lines.push(input_line)
#       else
#         markdown_lines.push(input_line)
#       end
#     end
#     # If needed, create page TOC and insert into markdown_lines.
#     unless page_toc_inclusion.nil?
#       toc_lines = [
#           page_toc_inclusion.page_toc_title + "\n",
#           '',
#       ]
#       page_toc_index =  markdown_lines.index(page_toc_inclusion.page_toc_line)
#       lines_to_scan = markdown_lines[page_toc_index + 1..-1]
#       create_page_toc(lines_to_scan, toc_lines)
#       markdown_lines.delete_at(page_toc_index)
#       markdown_lines.insert(page_toc_index, *toc_lines)
#     end
#     # Now review the markdown and include everything.
#     markdown_lines.each_with_index do |markdown_line, line_index|
#       match_data = markdown_line.match(INCLUDE_REGEXP)
#       unless match_data
#         output_lines.push(markdown_line)
#         next
#       end
#       treatment = match_data[1]
#       cited_includee_file_path = match_data[2]
#       new_inclusion = Inclusion.new(
#           markdown_line.chomp,
#           includer_file_path,
#           line_index + 1,
#           cited_includee_file_path,
#           treatment
#       )
#       inclusions.include(
#           new_inclusion,
#           output_lines,
#           self
#       )
#     end
#   end
#
#   def self.git_clone_dir_path
#     git_dir = `git rev-parse --show-toplevel`.chomp
#     unless $?.success?
#       message = <<EOT
#
# Markdown helper must run inside a .git project.
# That is, the working directory one of its parents must be a .git directory.
# EOT
#       raise RuntimeError.new(message)
#     end
#     git_dir
#   end
#
#   def self.path_in_project(path)
#     path.sub(MarkdownHelper.git_clone_dir_path + '/', '')
#   end
#
#   class Inclusions
#
#     attr_accessor :inclusions
#
#     def initialize
#       self.inclusions = []
#     end
#
#     def include(
#       new_inclusion,
#       output_lines,
#       markdown_helper
#     )
#       treatment = case new_inclusion.treatment
#                     when ':code_block'
#                       :code_block
#                     when ':markdown'
#                       :markdown
#                     when ':verbatim'
#                       message = "Treatment ':verbatim' is deprecated; please use treatment ':markdown'."
#                       warn(message)
#                       :markdown
#                     when ':comment'
#                       :comment
#                     when ':pre'
#                       :pre
#                     else
#                       new_inclusion.treatment
#                   end
#       if treatment == :markdown
#         check_circularity(new_inclusion)
#       end
#        includee_path_in_project = MarkdownHelper.path_in_project(new_inclusion.absolute_includee_file_path)
#       output_lines.push(MarkdownHelper.comment(" >>>>>> BEGIN INCLUDED FILE (#{treatment}): SOURCE #{includee_path_in_project} ")) unless markdown_helper.pristine
#       begin
#         include_lines = File.readlines(new_inclusion.absolute_includee_file_path)
#       rescue => e
#         inclusions.push(new_inclusion)
#         message = [
#             MISSING_INCLUDEE_EXCEPTION_LABEL,
#             backtrace_inclusions,
#         ].join("\n")
#         e = UnreadableInputError.new(message)
#         e.set_backtrace([])
#         raise e
#       end
#       last_line = include_lines.last
#       unless last_line && last_line.match("\n")
#         message = "Warning:  Included file has no trailing newline: #{new_inclusion.cited_includee_file_path}"
#         warn(message)
#       end
#       case treatment
#         when :markdown
#           # Pass through unadorned, but honor any nested includes.
#           inclusions.push(new_inclusion)
#           markdown_helper.send(:include_files, new_inclusion.absolute_includee_file_path, include_lines, output_lines, self)
#           inclusions.pop
#         when :comment
#           output_lines.push(MarkdownHelper.comment(include_lines.join('')))
#         when :pre
#           output_lines.push("<pre>\n")
#           output_lines.push(include_lines.join(''))
#           output_lines.push("</pre>\n")
#         else
#           # Use the file name as a label.
#           file_name_line = format("```%s```:\n", File.basename(new_inclusion.cited_includee_file_path))
#           output_lines.push(file_name_line)
#           # Put into code block.
#           language = treatment == :code_block ? '' : treatment
#           output_lines.push("```#{language}\n")
#           output_lines.push(*include_lines)
#           output_lines.push("```\n")
#       end
#       output_lines.push(MarkdownHelper.comment(" <<<<<< END INCLUDED FILE (#{treatment}): SOURCE #{includee_path_in_project} ")) unless markdown_helper.pristine
#     end
#
#     CIRCULAR_EXCEPTION_LABEL = 'Includes are circular:'
#     UNREADABLE_INPUT_EXCEPTION_LABEL = 'Could not read input file.'
#     UNWRITABLE_OUTPUT_EXCEPTION_LABEL = 'Could not write output file.'
#     MISSING_INCLUDEE_EXCEPTION_LABEL = 'Could not read include file,'
#     LEVEL_LABEL = '    Level'
#     BACKTRACE_LABEL = '  Backtrace (innermost include first):'
#
#     def check_circularity(new_inclusion)
#       previous_inclusions = inclusions.collect {|x| x.real_includee_file_path}
#       previously_included = previous_inclusions.include?(new_inclusion.real_includee_file_path)
#       if previously_included
#         inclusions.push(new_inclusion)
#         message = [
#             CIRCULAR_EXCEPTION_LABEL,
#             backtrace_inclusions,
#             ].join("\n")
#         e = MarkdownHelper::CircularIncludeError.new(message)
#         e.set_backtrace([])
#         raise e
#       end
#     end
#
#     def backtrace_inclusions
#       lines = [BACKTRACE_LABEL]
#       inclusions.reverse.each_with_index do |inclusion, i|
#         lines.push("#{LEVEL_LABEL} #{i}:")
#         level_lines = inclusion.to_lines(indentation_level = 3)
#         lines.push(*level_lines)
#       end
#       lines.join("\n")
#     end
#
#   end
#
#   class Inclusion
#
#     LINE_COUNT = 5
#
#     attr_accessor \
#       :includer_file_path,
#       :includer_line_number,
#       :include_description,
#       :absolute_includee_file_path,
#       :cited_includee_file_path,
#       :treatment,
#       :page_toc_title,
#       :page_toc_line
#
#     def initialize(
#         include_description,
#         includer_file_path,
#         includer_line_number,
#         cited_includee_file_path,
#         treatment
#     )
#       self.include_description = include_description
#       self.includer_file_path = includer_file_path
#       self.includer_line_number = includer_line_number
#       self.cited_includee_file_path = cited_includee_file_path
#       self.absolute_includee_file_path = absolute_includee_file_path
#       self.treatment = treatment
#       self.absolute_includee_file_path = File.absolute_path(File.join(
#           File.dirname(includer_file_path),
#           cited_includee_file_path,
#       ))
#     end
#
#     def real_includee_file_path
#       # Would raise exception unless exists.
#       return nil unless File.exist?(absolute_includee_file_path)
#       Pathname.new(absolute_includee_file_path).realpath.to_s
#     end
#
#     def indentation(level)
#       '  ' * level
#     end
#
#     def to_lines(indentation_level)
#       relative_inluder_file_path = MarkdownHelper.path_in_project(includer_file_path)
#       relative_inludee_file_path = MarkdownHelper.path_in_project(absolute_includee_file_path)
#        text = <<EOT
# #{indentation(indentation_level)}Includer:
# #{indentation(indentation_level+1)}Location: #{relative_inluder_file_path}:#{includer_line_number}
# #{indentation(indentation_level+1)}Include description: #{include_description}
# #{indentation(indentation_level)}Includee:
# #{indentation(indentation_level+1)}File path: #{relative_inludee_file_path}
# EOT
#       text.split("\n")
#     end
#
#   end
#
# end
#
