require 'tmpdir'

class MarkdownIrbRunner < MarkdownHelper

  IrbFilterPragma = '```#run_irb'
  BeginTextDirective = "=begin #{IrbFilterPragma}"
  EndTextDirective = "=end #{IrbFilterPragma}"

  def run_irb(template_file_path, markdown_file_path)
    irb_input = make_irb_input(template_file_path)
    irb_output = make_irb_output(irb_input)
    markdown = make_markdown(irb_output)
    File.write(markdown_file_path, markdown)
  end

  def make_irb_input(template_file_path)
    irb_lines = []
    irb_lines.push(BeginTextDirective)
    source_lines = File.readlines(template_file_path)
    source_lines.each do |source_line|
      source_line.chomp!
      if source_line == IrbFilterPragma
        irb_lines.push(EndTextDirective)
      elsif source_line == '```'
        irb_lines.push(BeginTextDirective)
      else
        irb_lines.push(source_line)
      end
    end
    irb_lines.push(EndTextDirective)
    irb_lines.push('') unless irb_lines.last.empty?
    irb_lines.join("\n")
  end

  def make_irb_output(irb_input)
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        File.write('irb_input', irb_input)
        command = 'irb --noecho irb_input | tail +2 | head --lines=-2 > irb_output'
        system(command )
        File.read('irb_output')
      end
    end
  end

  def make_markdown(irb_output)
    output_lines = []
    irb_lines = irb_output.split("\n")
    irb_lines.each_with_index do |irb_line, i|
      irb_line.chomp!
      if irb_line == BeginTextDirective
        output_lines.push('```') unless i == 0
        next
      end
      if irb_line == EndTextDirective
        output_lines.push('```ruby') unless i == irb_lines.size - 1
        next
      end
      output_lines.push(irb_line)
    end
    output_lines.push('') unless output_lines.last.nil? || output_lines.last.empty?
    output_lines.join("\n")
  end

end