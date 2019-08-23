class MarkdownIrbRunner < MarkdownHelper

  def run_irb(template_file_path, markdown_file_path)
    File.write(markdown_file_path, File.read(template_file_path))
  end
end