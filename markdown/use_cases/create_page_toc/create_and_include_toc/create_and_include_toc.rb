require_relative '../create_page_toc_use_case'

class CreateAndIncludeToc < CreatePageTocUseCase

  RUBY_FILE_NAME = 'create_and_include.rb'
  API_COMMAND = "ruby #{RUBY_FILE_NAME}"

  CLI_COMMANDS_FILE_NAME = 'create_and_include.sh'
  CLI_COMMAND = "bash #{CLI_COMMANDS_FILE_NAME}"

  def self.build

    use_case_name = File.basename(__FILE__, '.rb')
    use_case = self.new(use_case_name)

    use_case.write_text_file
    use_case.write_includer_file

    File.write(
        CLI_COMMANDS_FILE_NAME,
        <<EOT
# Option --pristine suppresses comment insertion.
markdown_helper create_page_toc --pristine #{TEXT_FILE_NAME} #{TOC_FILE_NAME}
markdown_helper include --pristine #{INCLUDER_FILE_NAME} #{PAGE_FILE_NAME}
EOT
    )
    use_case.commands_to_execute.push(API_COMMAND)

    File.write(
        RUBY_FILE_NAME,
        <<EOT
require 'markdown_helper'

# Option :printine suppresses the addition of comments.
markdown_helper = MarkdownHelper.new(:pristine => true)
markdown_helper.create_page_toc('#{TEXT_FILE_NAME}', '#{TOC_FILE_NAME}')
markdown_helper.include('#{INCLUDER_FILE_NAME}', '#{PAGE_FILE_NAME}')
EOT
    )
    use_case.commands_to_execute.push(CLI_COMMAND)

    File.write(
        TEMPLATE_FILE_NAME,
        <<EOT
### Create a Table of Contents for a Markdown Page.

1.  Maintain markdown text in a separate file.
2.  Create a table of contents for the text.
3.  Use an includer file to include the contents and the text.

#### Text File

It's big, so linking instead of including:

[text file](#{TEXT_FILE_NAME})

#### Includer File

@[:markdown](#{INCLUDER_FILE_NAME}

#### CLI

You can use the command-line interface to perform the creation and inclusion.

##### Command

@[sh](#{CLI_COMMANDS_FILE_NAME})

@[:markdown](../../pristine.md)

#### API

You can use the API to perform the creation and inclusion.

##### Ruby Code

@[ruby](#{RUBY_FILE_NAME})

##### Command

```sh
#{API_COMMAND}
```

### Finished Page
            
It's big, so linking instead of including:

[page file](#{PAGE_FILE_NAME})

EOT

    )

    use_case.build

  end

end