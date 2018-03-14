require 'markdown_helper/version'

# Helper class for working with GitHub markdown.
#  Supports file inclusion.
#
# @author Burdette Lamar
class MarkdownHelper

  IMAGE_REGEXP = /^!\[([^\[]+)\]\(([^)]+)\)/
  INCLUDE_REGEXP = /^@\[([^\[]+)\]\(([^)]+)\)/

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

  # Get the user name and repository name from ENV.
  def repo_user_and_name
    repo_user = ENV['REPO_USER']
    repo_name = ENV['REPO_NAME']
    unless repo_user and repo_name
      message = 'ENV values for both REPO_USER and REPO_NAME must be defined.'
      raise RuntimeError.new(message)
    end
    [repo_user, repo_name]
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
  # @example pragma to include text verbatim, to be rendered as markdown.
  #   @[:verbatim](foo.md)
  def include(template_file_path, markdown_file_path)
    output = send(:generate_file, template_file_path, markdown_file_path, __method__) do |input_lines, output_lines|
      input_lines.each do |input_line|
        match_data = input_line.match(INCLUDE_REGEXP)
        unless match_data
          output_lines.push(input_line)
          next
        end
        treatment = case match_data[1]
                      when ':code_block'
                        :code_block
                      when ':verbatim'
                        :verbatim
                      when ':comment'
                        :comment
                      else
                        match_data[1]
                    end
        relative_file_path = match_data[2]
        include_file_path = File.join(
            File.dirname(template_file_path),
            relative_file_path,
        )
        send(:include_file, include_file_path, treatment, output_lines)
      end
    end
    output
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
  #   absolute_file_path = File.join(
  #       "https://raw.githubusercontent.com/#{repo_user}/#{repo_name}/master",
  #       relative_file_path,
  #   )
  def resolve(template_file_path, markdown_file_path)
    # Method :generate_file does the first things, yields the block, does the last things.
    output = send(:generate_file, template_file_path, markdown_file_path, __method__) do |input_lines, output_lines|
      input_lines.each do |input_line|
        match_data = input_line.match(IMAGE_REGEXP)
        unless match_data
          output_lines.push(input_line)
          next
        end
        send(:comment_resolve, input_line, output_lines) do
          alt_text = match_data[1]
          relative_file_path, attributes_s = match_data[2].split(/\s?\|\s?/, 2)
          attributes = attributes_s ? attributes_s.split(/\s+/) : []
          formatted_attributes = ['']
          attributes.each do |attribute|
            name, value = attribute.split('=', 2)
            formatted_attributes.push(format('%s="%s"', name, value))
          end
          formatted_attributes_s = formatted_attributes.join(' ')
          repo_user, repo_name = repo_user_and_name
          absolute_file_path = nil
          if relative_file_path.start_with?('http')
            absolute_file_path = relative_file_path
          else
            absolute_file_path = File.join(
                "https://raw.githubusercontent.com/#{repo_user}/#{repo_name}/master",
                relative_file_path,
            )
          end
          following_text = input_line.sub(IMAGE_REGEXP, '').chomp
          line = format(
              '<img src="%s" alt="%s"%s>%s',
              absolute_file_path,
              alt_text,
              formatted_attributes_s,
              following_text
          ) + "\n"
          output_lines.push(line)
        end
      end
    end
    output
  end
  alias resolve_image_urls resolve

  def comment(text)
    "<!--#{text}-->\n"
  end

  private

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

  def include_file(include_file_path, treatment, output_lines)
    include_file = File.new(include_file_path, 'r')
    output_lines.push(comment(" >>>>>> BEGIN INCLUDED FILE (#{treatment}): SOURCE #{include_file.path} ")) unless pristine
    included_text = include_file.read
    unless included_text.match("\n")
      message = "Warning:  Included file has no trailing newline: #{include_file_path}"
      warn(message)
    end
    case treatment
      when :verbatim
        # Pass through unadorned.
        output_lines.push(included_text)
      when :comment
        output_lines.push(comment(included_text))
      else
        # Use the file name as a label.
        file_name_line = format("<code>%s</code>\n", File.basename(include_file_path))
        output_lines.push(file_name_line)
        # Put into code block.
        language = treatment == :code_block ? '' : treatment
        output_lines.push("```#{language}\n")
        output_lines.push(included_text)
        output_lines.push("```\n")
    end
    output_lines.push(comment(" <<<<<< END INCLUDED FILE (#{treatment}): SOURCE #{include_file.path} ")) unless pristine
  end

  def comment_resolve(description, output_lines)
    output_lines.push(comment(" >>>>>> BEGIN RESOLVED IMAGE: DESCRIPTION '#{description}' ")) unless pristine
    yield
    output_lines.push(comment(" <<<<<< END RESOLVED IMAGE: DESCRIPTION '#{description}' ")) unless pristine
  end

end
