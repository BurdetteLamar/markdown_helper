require 'markdown_helper/version'

class MarkdownHelper

  FILE_SOURCE_TAG_REGEX = /^@\[(:code_block|:verbatim|\w+)\]/

  attr_accessor :tag_as_generated

    DEFAULT_treatment_FOR_FILE_EXT = {
      :md => :verbatim,
      :rb => 'ruby',
      :xml => 'xml',
      }

  def initialize
    @treatment_for_file_ext = DEFAULT_treatment_FOR_FILE_EXT
    @treatment_for_file_ext.default = :code_block
    self.tag_as_generated = false
  end

  def get_treatment(file_type)
    @treatment_for_file_ext[file_type]
  end

  def set_treatment(file_type, treatment)
    treatment_symbols = [:verbatim, :code_block]
    if treatment_symbols.include?(treatment) || treatment.kind_of?(String)
      @treatment_for_file_ext[file_type] = treatment
    else
      message = "treatment must be a single word or must be in #{treatment_symbols.inspect}, not #{treatment.inspect}"
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
        match_data = input_line.match(FILE_SOURCE_TAG_REGEX)
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
        p treatment
        file_path_in_parens =  input_line.sub(FILE_SOURCE_TAG_REGEX, '')
        unless file_path_in_parens.start_with?('(') && file_path_in_parens.end_with?(")\n")
          raise RuntimeError.new
        end
        relative_file_path = file_path_in_parens.sub('(', '').sub(")\n", '')
        p relative_file_path
        include_file_path = File.join(
            File.dirname(template_file_path),
            relative_file_path,
        )
        included_text = File.read(include_file_path)
        unless included_text.match("\n")
          message = "Warning:  Included file has no trailing newline: #{include_file_path}"
          warn(message)
        end
        extname = File.extname(include_file_path)
        file_ext_key = extname.sub('.', '').to_sym
        treatment ||= @treatment_for_file_ext[file_ext_key]
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