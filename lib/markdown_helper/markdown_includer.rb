require 'pathname'

class MarkdownIncluder < MarkdownHelper

  INCLUDE_REGEXP = /^@\[([^\[]+)\]\(([^)]+)\)$/
  INCLUDE_MARKDOWN_REGEXP = /^@\[:markdown\]\(([^)]+)\)$/

  def include(template_file_path, markdown_file_path)
    @inclusions = []
    generate_file(:include, template_file_path, markdown_file_path) do |output_lines|
      Dir.chdir(File.dirname(template_file_path)) do
        markdown_lines = include_markdown(template_file_path)
        markdown_lines = include_page_toc(markdown_lines)
        include_all(template_file_path, markdown_lines, output_lines)
      end
    end

  end

  def MarkdownIncluder.pre(text)
    "<pre>\n#{text}</pre>"
  end

  def MarkdownIncluder.details(text)
    "<details>\n#{text}</details>"
  end

  def include_markdown(template_file_path)
    Dir.chdir(File.dirname(template_file_path)) do
      markdown_lines = []
      unless File.readable?(template_file_path)
        path_in_project = MarkdownHelper.path_in_project(template_file_path )
        message = [
            "Could not read template file: #{path_in_project}",
            MarkdownIncluder.backtrace_inclusions(@inclusions),
        ].join("\n")
        e = UnreadableTemplateError.new(message)
        e.set_backtrace([])
        raise e
      end
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
            includee_file_path,
            @inclusions
        )
        case treatment
        when ':markdown'
          check_includee(inclusion)
          check_circularity(inclusion)
          @inclusions.push(inclusion)
          includee_lines = include_markdown(File.absolute_path(includee_file_path))
          markdown_lines.concat(includee_lines)
        when ':comment'
          text = File.read(includee_file_path)
          markdown_lines.push(MarkdownHelper.comment(text))
          @inclusions.push(inclusion)
        when ':pre'
          text = File.read(includee_file_path)
          markdown_lines.push(MarkdownIncluder.pre(text))
          @inclusions.push(inclusion)
        when ':details'
          text = File.read(includee_file_path)
          markdown_lines.push(MarkdownIncluder.details(text))
          @inclusions.push(inclusion)
        else
          markdown_lines.push(template_line)
          next
        end
        @inclusions.pop
        treatment.sub!(/^:/, '')
        add_inclusion_comments(treatment, includee_file_path, markdown_lines)
      end
      markdown_lines
    end
  end

  def include_page_toc(template_lines)
    toc_line_index = nil
    toc_title = nil
    anchor_counts = Hash.new(0)
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
      line = input_line.chomp
      heading = Heading.parse(line)
      next unless heading
      if i < toc_line_index
        heading.link(anchor_counts)
        next
      end
      first_heading_level ||= heading.level
      indentation = '  ' * (heading.level - first_heading_level)
      toc_line = "#{indentation}- #{heading.link(anchor_counts)}"
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
          includee_file_path,
          @inclusions
      )
      check_includee(inclusion)
      @inclusions.push(inclusion)
      file_marker = format('```%s```:', File.basename(includee_file_path))
      begin_backticks = '```'
      end_backticks = '```'
      begin_backticks += treatment unless treatment.start_with?(':')
      includee_lines = File.read(includee_file_path).split("\n")
      includee_lines.unshift(begin_backticks)
      includee_lines.unshift(file_marker)
      includee_lines.push(end_backticks)
      add_inclusion_comments(treatment.sub(':', ''), includee_file_path, includee_lines)
      output_lines.concat(includee_lines)
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


    def link(anchor_counts = Hash.new(0))
      remove_regexp = /[\=\#\(\)\[\]\{\}\.\?\+\*\`\"\']+/
      to_hyphen_regexp = /\W+/
      anchor = title.
          gsub(remove_regexp, '').
          gsub(to_hyphen_regexp, '-').
          downcase
      anchor_count = anchor_counts[anchor]
      anchor_counts[anchor] += 1
      suffix = (anchor_count == 0) ? '' : "-#{anchor_count}"
      "[#{title}](##{anchor}#{suffix})"
    end
  end

  def check_circularity(inclusion)
    included_file_paths = @inclusions.collect { |x| x.includee_real_file_path}
    previously_included = included_file_paths.include?(inclusion.includee_real_file_path)
    if previously_included
      @inclusions.push(inclusion)
      message = [
          'Includes are circular:',
          MarkdownIncluder.backtrace_inclusions(@inclusions),
      ].join("\n")
      e = CircularIncludeError.new(message)
      e.set_backtrace([])
      raise e
    end
  end

  def check_includee(inclusion)
    unless File.readable?(inclusion.includee_absolute_file_path)
      @inclusions.push(inclusion)
      message = [
          'Could not read includee file:',
          MarkdownIncluder.backtrace_inclusions(@inclusions),
      ].join("\n")
      e = UnreadableIncludeeError.new(message)
      e.set_backtrace([])
      raise e
    end

  end

  def self.backtrace_inclusions(inclusions)
    lines = ['  Backtrace (innermost include first):']
    inclusions.reverse.each_with_index do |inclusion, i|
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
      :include_pragma,
      :treatment,
      :includer_line_number,
      :cited_includee_file_path,
      :includee_absolute_file_path

    def initialize(
        includer_file_path,
        include_pragma,
        includer_line_number,
        treatment,
        cited_includee_file_path,
        inclusions
    )
      self.includer_file_path = includer_file_path
      self.include_pragma = include_pragma
      self.includer_line_number = includer_line_number
      self.treatment = treatment
      self.cited_includee_file_path = cited_includee_file_path

      self.includer_absolute_file_path = File.absolute_path(includer_file_path)
      unless File.exist?(self.includer_absolute_file_path)
        fail self.includer_absolute_file_path
      end

      self.includee_absolute_file_path = File.absolute_path(File.join(
          File.dirname(includer_file_path),
          cited_includee_file_path,
          ))
    end

    def includer_real_file_path
      Pathname.new(includer_absolute_file_path).realpath.to_s
    end

    def includee_real_file_path
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
#{indentation(indentation_level+1)}Include pragma: #{include_pragma}
#{indentation(indentation_level)}Includee:
#{indentation(indentation_level+1)}File path: #{relative_inludee_file_path}
EOT
      text.split("\n")
    end

  end

end
