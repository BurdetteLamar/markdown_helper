require 'markdown_helper/version'

# Helper class for working with GitHub markdown.
#  Supports file inclusion.
#
# @author Burdette Lamar
class MarkdownHelper

  INCLUDE_REGEXP = /^@\[(:code_block|:verbatim|\w+)\]/

  # Merges external files into markdown text.
  # @param template_file_path [String] the path to the input template markdown file, usually containing include pragmas.
  # @param markdown_file_path [String] the path to the output merged markdown file.
  # @raise [RuntimeError] if an include pragma parsing error occurs.
  # @return [String] the resulting markdown text.
  #
  # @example Pragma to include text as a highlighted code block.
  #   @[ruby](foo.rb)
  #
  # @example Pragma to include text as a plain code block.
  #   @[:code_block](foo.xyz)
  #
  # @example Pragma to include text verbatim, to be rendered as markdown.
  #   @[:verbatim](foo.md)
  def include(template_file_path, markdown_file_path)
    output_lines = []
    File.open(template_file_path, 'r') do |template_file|
      # For later.
      # if tag_as_generated
      #   output_lines.push("<!--- GENERATED FILE, DO NOT EDIT --->\n")
      # end
      template_file.each_line do |input_line|
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
                      else
                        match_data[1]
                    end
        file_path_in_parens =  input_line.sub(INCLUDE_REGEXP, '')
        unless file_path_in_parens.start_with?('(') && file_path_in_parens.end_with?(")\n")
          raise RuntimeError.new(file_path_in_parens.inspect)
        end
        relative_file_path = file_path_in_parens.sub('(', '').sub(")\n", '')
        include_file_path = File.join(
            File.dirname(template_file_path),
            relative_file_path,
        )
        included_text = File.read(include_file_path)
        unless included_text.match("\n")
          message = "Warning:  Included file has no trailing newline: #{include_file_path}"
          warn(message)
        end
        # For later.
        # extname = File.extname(include_file_path)
        # file_ext_key = extname.sub('.', '').to_sym
        # treatment ||= @treatment_for_file_ext[file_ext_key]
        if treatment == :verbatim
          # Pass through unadorned.
          output_lines.push(included_text)
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
      end
    end
    output = output_lines.join('')
    File.open(markdown_file_path, 'w') do |md_file|
      md_file.write(output)
    end
    output
  end

end