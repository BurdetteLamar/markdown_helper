require 'markdown_helper/version'

class MarkdownHelper

  FILE_SOURCE_TAG = '[include_file]'

  attr_accessor :tag_as_generated

  VERBATIM = nil
  CODE_BLOCK = ''

  DEFAULT_HANDLING_FOR_FILE_EXT = {
      :md => VERBATIM,
      :rb => 'ruby',
      :xml => 'xml',
      }

  def initialize
    @handling_for_file_ext = DEFAULT_HANDLING_FOR_FILE_EXT
    @handling_for_file_ext.default = CODE_BLOCK
    self.tag_as_generated = false
  end

  def highlight_file_type(file_type, language)
    @handling_for_file_ext[file_type] = language
  end

  def code_block_file_type(file_type)
    @handling_for_file_ext[file_type] = CODE_BLOCK
  end

  def verbatim_file_type(file_type)
    @handling_for_file_ext[file_type] = VERBATIM
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
        relative_path = input_line.sub(FILE_SOURCE_TAG, '').gsub(/[()]/, '').strip
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
        handling_for_file_ext_key = extname.sub('.', '').to_sym
        language = @handling_for_file_ext[handling_for_file_ext_key]
        if language.nil?
          # Pass through unadorned.
          output_lines.push(included_text)
        else
          # Treat as code block.
          # Label the block with its file name.
          file_name_line = format("<code>%s</code>\n", File.basename(include_file_path))
          output_lines.push(file_name_line)
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