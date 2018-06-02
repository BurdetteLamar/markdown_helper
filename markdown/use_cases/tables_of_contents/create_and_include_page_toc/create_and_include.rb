require 'markdown_helper'

# Option :printine suppresses the addition of comments.
markdown_helper = MarkdownHelper.new(:pristine => true)
markdown_helper.create_page_toc('text.md', 'toc.md')
markdown_helper.include('includer.md', 'page.md')
