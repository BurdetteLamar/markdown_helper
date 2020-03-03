require 'tmpdir'

class MarkdownIrbRunner < MarkdownHelper

  CommentPrefix = '#run_irb '

  ##
  # Run Ruby Interactive Shell (irb) for each embedded snippet
  # that begins with '```#run_irb' and end with '```'.
  # The irb output replaces the entire sequence,
  # and is preceded by '```ruby' and followed by '```'.
  def run_irb(template_file_path, markdown_file_path)
    irb_input = make_irb_input(template_file_path)
    irb_output = make_irb_output(irb_input)
    markdown = make_markdown(irb_output)
    File.write(markdown_file_path, markdown)
  end

  ##
  # Comment out all lines except the irb snippets.
  def make_irb_input(template_file_path)
    irb_lines = []
    in_irb_block = false
    source_lines = File.readlines(template_file_path)
    source_lines.each do |source_line|
      source_line.chomp!
      if source_line == '```#run_irb'
        # Begin irb snippet; put commented-out markdown pragma.
        in_irb_block = true
        irb_lines.push(CommentPrefix + '```ruby')
      elsif source_line == '```'
        # End irb snippet;  put commented-out markdown pragma.
        in_irb_block = false
        irb_lines.push(CommentPrefix + '```')
      else
        if in_irb_block
          irb_lines.push(source_line)
        else
          irb_lines.push(CommentPrefix + source_line)
        end
      end
    end
    irb_lines.push('') unless irb_lines.last.empty?
    irb_lines.join("\n")
  end

  ##
  # Run irb over the prepared file.
  def make_irb_output(irb_input)
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        File.write('irb_input', irb_input)
        command = 'irb --noecho --noprompt irb_input > irb_output'
        system(command)
        File.read('irb_output')
      end
    end
  end

  ##
  # Uncomment the text.
  def make_markdown(irb_output)
    output_lines = []
    irb_lines = irb_output.split("\n")
    irb_lines.each_with_index do |irb_line, i|
      irb_line.chomp!
      next if (i == 0) && (irb_line == 'Switch to inspect mode.')

      output_line = irb_line.sub(CommentPrefix, '')
      output_lines.push(output_line)
    end
    output_lines.push('') unless output_lines.last.nil? || output_lines.last.empty?
    output_lines.join("\n")
  end

end