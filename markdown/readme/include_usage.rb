require 'markdown_helper'

template_file_path = 'highlight_ruby_template.md'
markdown_file_path = 'highlighted_ruby.md'
markdown_helper = MarkdownHelper.new
# Pristine.
markdown_helper.include(template_file_path, markdown_file_path)
markdown_helper.pristine = true
markdown_helper.include(template_file_path, markdown_file_path)
# Also pristine.
markdown_helper = MarkdownHelper.new(:pristine => true)
markdown_helper.include(template_file_path, markdown_file_path)
