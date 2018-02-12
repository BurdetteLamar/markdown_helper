require 'markdown_helper/version'

class MarkdownHelper

  FILE_SOURCE_TAG = '[include_file]'

  attr_accessor :tag_as_generated

    DEFAULT_HANDLING_FOR_FILE_EXT = {
      :md => :verbatim,
      :rb => 'ruby',
      :xml => 'xml',
      }

  def initialize
    @handling_for_file_ext = DEFAULT_HANDLING_FOR_FILE_EXT
    @handling_for_file_ext.default = :code_block
    self.tag_as_generated = false
  end

  def get_handling(file_type)
    @handling_for_file_ext[file_type]
  end

  def set_handling(file_type, handling)
    handling_symbols = [:verbatim, :code_block]
    if handling_symbols.include?(handling) || handling.kind_of?(String)
      @handling_for_file_ext[file_type] = handling
    else
      message = "Handling must be a single word or must be in #{handling_symbols.inspect}, not #{handling.inspect}"
      raise ArgumentError.new(message)
    end
  end

  def include(template_file_path, markdown_file_path)
    output_lines = []
    File.open(template_file_path, 'r') do |template_file|
      if tag_as_generated
        output_lines.push("<!--- GENERATED FILE, DO NOT EDIT --->\n")
      end
      template_file.each_line do |input_line|
        unless input_line.start_with?(FILE_SOURCE_TAG)
          output_lines.push(input_line)
          next
        end
        relative_path, handling_token = input_line.sub(FILE_SOURCE_TAG, '').gsub(/[()]/, '').strip.split('|')
        handling = handling_token ? handling_token.to_sym : nil
        include_file_path = File.join(
            File.dirname(template_file_path),
            relative_path,
        )
        included_text = File.read(include_file_path)
        unless included_text.match("\n")
          message = "Warning:  Included file has no trailing newline: #{include_file_path}"
          warn(message)
        end
        extname = File.extname(include_file_path)
        file_ext_key = extname.sub('.', '').to_sym
        handling ||= @handling_for_file_ext[file_ext_key]
        if handling == :verbatim
          # Pass through unadorned.
          output_lines.push(included_text)
        else
          # Use the file name as a label.
          file_name_line = format("<code>%s</code>\n", File.basename(include_file_path))
          output_lines.push(file_name_line)
          # Put into code block.
          language = handling == :code_block ? '' : handling
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