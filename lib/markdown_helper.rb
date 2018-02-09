require 'markdown_helper/version'

module MarkdownHelper

  class Features

    attr_accessor \
      :code_block,
      :tag_as_generated

    def initialize(code_block = nil)
      self.code_block = code_block
    end

  end

  FILE_SOURCE_TAG = '[include_file]'

  DEFAULT_FEATURES = Features.new(
      code_block: {
          :rb => 'ruby',
          :xml => 'xml',
      },
      tag_as_generated: false
  )

  def self.include(template_file_path, markdown_file_path, features = DEFAULT_FEATURES)
    output_lines = []
    File.open(template_file_path, 'r') do |template_file|
      if features.tag_as_generated
        output_lines.push('<!--- GENERATED FILE, DO NOT EDIT --->')
      end
      template_file.each_line do |input_line|
        unless input_line.start_with?(FILE_SOURCE_TAG)
          output_lines.push(input_line)
        else
          relative_path = input_line.sub(FILE_SOURCE_TAG, '').gsub(/[()]/, '').strip
          include_file_path = File.join(
              File.dirname(template_file_path),
              relative_path,
          )
          file_source = File.read(include_file_path)
          extname = File.extname(include_file_path)
          highlight_language = features.code_block[extname.to_sym]
          unless highlight_language
            # Pass through unadorned.
            output_lines.push(file_source)
          else
            # Treat as code block.
            # Label the block with its file name.
            file_name_line = format('<code>%s</code>', File.basename(include_file_path))
            output_lines.push(file_name_line)
            output_lines.push("```#{highlight_language}")
            output_lines.push(file_source)
            output_lines.push('```')
          end
        end
      end
    end
    File.open(markdown_file_path, 'w') do |md_file|
      md_file.write(output_lines.join(''))
    end
  end

end