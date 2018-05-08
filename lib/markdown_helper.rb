require 'pathname'
require 'markdown_helper/version'

# Helper class for working with GitHub markdown.
#  Supports file inclusion.
#
# @author Burdette Lamar
class MarkdownHelper

  IMAGE_REGEXP = /!\[([^\[]+)\]\(([^)]+)\)/
  INCLUDE_REGEXP = /^@\[([^\[]+)\]\(([^)]+)\)$/

  attr_accessor :pristine

  def initialize(options = {})
    default_options = {
        :pristine => false,
    }
    merged_options = default_options.merge(options)
    merged_options.each_pair do |method, value|
      unless self.respond_to?(method)
        raise ArgumentError.new("Unknown option: #{method}")
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
      send(:include_files, template_file_path, input_lines, output_lines, markdown_inclusions = {})
    end
  end

  # Resolves relative image paths to absolute urls in markdown text.
  # @param template_file_path [String] the path to the input template markdown file, usually containing image pragmas.
  # @param markdown_file_path [String] the path to the output resolved markdown file.
  # @return [String] the resulting markdown text.
  #
  # This matters because when markdown becomes part of a Ruby gem,
  # its images will have been relocated in the documentation at RubyDoc.info, breaking the paths.
  # The resolved (absolute) urls, however, will still be valid.
  #
  # ENV['REPO_USER'] and ENV['REPO_NAME'] must give the user name and repository name of the relevant GitHub repository.
  #  must give the repo name of the relevant GitHub repository.
  #
  # @example pragma for an image:
  #   ![image_icon](images/image.png)
  #
  # The path resolves to:
  #
  #   image_path = File.join(
  #       "https://raw.githubusercontent.com/#{repo_user}/#{repo_name}/master",
  #       relative_file_path,
  #   )
  def resolve(template_file_path, markdown_file_path)
    # Method :generate_file does the first things, yields the block, does the last things.
    send(:generate_file, template_file_path, markdown_file_path, __method__) do |input_lines, output_lines|
      send(:resolve_images, template_file_path, input_lines, output_lines)
    end
  end
  alias resolve_image_urls resolve

  private

  def comment(text)
    "<!--#{text}-->\n"
  end

  def repo_user_and_name
    repo_user = ENV['REPO_USER']
    repo_name = ENV['REPO_NAME']
    unless repo_user and repo_name
      message = 'ENV values for both REPO_USER and REPO_NAME must be defined.'
      raise RuntimeError.new(message)
    end
    [repo_user, repo_name]
  end

  def generate_file(template_file_path, markdown_file_path, method)
    output_lines = []
    File.open(template_file_path, 'r') do |template_file|
      output_lines.push(comment(" >>>>>> BEGIN GENERATED FILE (#{method.to_s}): SOURCE #{template_file_path} ")) unless pristine
      input_lines = template_file.readlines
      yield input_lines, output_lines
      output_lines.push(comment(" <<<<<< END GENERATED FILE (#{method.to_s}): SOURCE #{template_file_path} ")) unless pristine
    end
    output = output_lines.join('')
    File.open(markdown_file_path, 'w') do |md_file|
      md_file.write(output)
    end
    output
  end

  def include_files(includer_file_path, input_lines, output_lines, markdown_inclusions)

    input_lines.each_with_index do |input_line, line_index|
      match_data = input_line.match(INCLUDE_REGEXP)
      unless match_data
        output_lines.push(input_line)
        next
      end
      treatment = match_data[1]
      relative_included_file_path = match_data[2]
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
          includer_file_path,
          includer_line_number = line_index + 1,
          relative_included_file_path
      )
      included_real_path = new_inclusion.included_real_path
      if treatment == :markdown
        previously_included = markdown_inclusions.include?(included_real_path)
        if previously_included
          markdown_inclusions.store(included_real_path, new_inclusion)
          backtrace('Includes are circular', markdown_inclusions, 'RuntimeError')
        end
      end
      output_lines.push(comment(" >>>>>> BEGIN INCLUDED FILE (#{treatment}): SOURCE #{new_inclusion.included_file_path} ")) unless pristine
      include_lines = File.readlines(new_inclusion.included_file_path)
      unless include_lines.last.match("\n")
        message = "Warning:  Included file has no trailing newline: #{relative_included_file_path}"
        warn(message)
      end
      case treatment
        when :markdown
          # Pass through unadorned, but honor any nested includes.
          markdown_inclusions.store(included_real_path, new_inclusion)
          include_files(new_inclusion.included_file_path, include_lines, output_lines, markdown_inclusions)
          markdown_inclusions.delete(included_real_path)
        when :comment
          output_lines.push(comment(include_lines.join('')))
        when :pre
          output_lines.push("<pre>\n")
          output_lines.push(include_lines.join(''))
          output_lines.push("</pre>\n")
        else
          # Use the file name as a label.
          file_name_line = format("```%s```:\n", File.basename(relative_included_file_path))
          output_lines.push(file_name_line)
          # Put into code block.
          language = treatment == :code_block ? '' : treatment
          output_lines.push("```#{language}\n")
          output_lines.push(*include_lines)
          output_lines.push("```\n")
      end
      output_lines.push(comment(" <<<<<< END INCLUDED FILE (#{treatment}): SOURCE #{new_inclusion.included_file_path} ")) unless pristine
    end
  end

  def resolve_images(template_file_path, input_lines, output_lines)
    input_lines.each do |input_line|
      scan_data = input_line.scan(IMAGE_REGEXP)
      if scan_data.empty?
        output_lines.push(input_line)
        next
      end
      output_lines.push(comment(" >>>>>> BEGIN RESOLVED IMAGES: INPUT-LINE '#{input_line}' ")) unless pristine
      output_line = input_line
      scan_data.each do |alt_text, path_and_attributes|
        original_image_file_path, attributes_s = path_and_attributes.split(/\s?\|\s?/, 2)

        # Attributes.
        attributes = attributes_s ? attributes_s.split(/\s+/) : []
        formatted_attributes = ['']
        attributes.each do |attribute|
          name, value = attribute.split('=', 2)
          formatted_attributes.push(format('%s="%s"', name, value))
        end
        formatted_attributes_s = formatted_attributes.join(' ')

        if original_image_file_path.start_with?('http')
          image_path = original_image_file_path
        else
          git_dir = `git rev-parse --git-dir`.chomp
          if git_dir == '.git'
            git_clone_dir_path = `pwd`.chomp
          else
            git_clone_dir_path = File.dirname(git_dir).chomp
          end
          git_clone_dir_pathname = Pathname.new(git_clone_dir_path.sub(%r|/c/|, 'C:/')).realpath
          git_clone_dir_path = git_clone_dir_pathname.to_s
          absolute_template_file_path = File.absolute_path(template_file_path)
          template_dir_path = File.dirname(absolute_template_file_path)
          absolute_file_path = File.join(
              template_dir_path,
              original_image_file_path,
          )
          absolute_file_path = Pathname.new(absolute_file_path).cleanpath.to_s
          relative_image_file_path = absolute_file_path.sub(git_clone_dir_path + '/', '')
          repo_user, repo_name = repo_user_and_name
          image_path = File.join(
              "https://raw.githubusercontent.com/#{repo_user}/#{repo_name}/master",
              relative_image_file_path,
          )
        end
        img_element = format(
            '<img src="%s" alt="%s"%s>',
            image_path,
            alt_text,
            formatted_attributes_s,
        )
        output_line = output_line.sub(IMAGE_REGEXP, img_element)
      end
      output_lines.push(output_line)
      output_lines.push(comment(" <<<<<< END RESOLVED IMAGES: INPUT-LINE '#{input_line}' ")) unless pristine
    end

  end

  def backtrace(label, markdown_inclusions, exception_name)
    message_lines = ["#{label}:"]
    i = 0
    markdown_inclusions.each_with_index do |path_and_inclusion, i|
      _, inclusion = *path_and_inclusion
      message_lines.push("  Level #{i}:")
      message_lines.push("    Includer: #{inclusion.includer_file_path}:#{inclusion.includer_line_number}")
      message_lines.push("    Relative file path: #{inclusion.relative_included_file_path}")
      message_lines.push("    Included file path: #{inclusion.included_file_path}")
      message_lines.push("    Real file_path: #{inclusion.included_real_path}")
    end
    message = message_lines.join("\n")
    raise Object.const_get(exception_name).new(message)
    raise RuntimeError.new(message)
  end

  class Inclusion

    attr_accessor \
      :includer_file_path,
      :includer_line_number,
      :relative_included_file_path,
      :included_file_path,
      :included_real_path

    def initialize(
        includer_file_path,
        includer_line_number,
        relative_included_file_path
    )
      included_file_path = File.join(
          File.dirname(includer_file_path),
          relative_included_file_path,
      )
      self.includer_file_path = includer_file_path
      self.includer_line_number = includer_line_number
      self.relative_included_file_path = relative_included_file_path
      self.included_file_path = included_file_path
      self.included_real_path = Pathname.new(included_file_path).realpath.to_s
    end

  end

end

