require 'markdown_helper'

markdown_helper = MarkdownHelper.new
template_file_path = 'template.md'
markdown_file_path = 'markdown.md'
markdown_helper.resolve(template_file_path, markdown_file_path)
