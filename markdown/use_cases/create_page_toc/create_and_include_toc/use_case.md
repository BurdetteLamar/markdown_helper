### Create a Table of Contents for a Markdown Page.

1.  Maintain markdown text in a separate file.
2.  Create a table of contents for the text.
3.  Use an includer file to include the contents and the text.

#### Text File

It's big, so linking instead of including:

[text file](text.md)

#### Includer File

@[:markdown](includer.md

#### CLI

You can use the command-line interface to perform the creation and inclusion.

##### Command

```create_and_include.sh```:
```sh
# Option --pristine suppresses comment insertion.
markdown_helper create_page_toc --pristine text.md toc.md
markdown_helper include --pristine includer.md page.md
```

(Option ```--pristine``` suppresses comment insertion.)

#### API

You can use the API to perform the creation and inclusion.

##### Ruby Code

```create_and_include.rb```:
```ruby
require 'markdown_helper'

# Option :printine suppresses the addition of comments.
markdown_helper = MarkdownHelper.new(:pristine => true)
markdown_helper.create_page_toc('text.md', 'toc.md')
markdown_helper.include('includer.md', 'page.md')
```

##### Command

```sh
ruby create_and_include.rb
```

### Finished Page
            
It's big, so linking instead of including:

[page file](page.md)

