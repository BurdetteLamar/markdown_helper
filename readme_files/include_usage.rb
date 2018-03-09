require 'markdown_helper'

markdown_helper = MarkdownHelper.new
template_file_path = 'highlight_ruby_template.md'
markdown_file_path = 'highlighted_ruby.md'
markdown_helper.include(template_file_path, markdown_file_path)
