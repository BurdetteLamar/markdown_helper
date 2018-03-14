require 'markdown_helper'

template_file_path = 'template.md'
markdown_file_path = 'markdown.md'
markdown_helper = MarkdownHelper.new
markdown_helper.resolve(template_file_path, markdown_file_path)
# Pristine.
markdown_helper.pristine = true
markdown_helper.resolve(template_file_path, markdown_file_path)
# Also pristine.
markdown_helper = MarkdownHelper.new(:pristine => true)
markdown_helper.resolve(template_file_path, markdown_file_path)
