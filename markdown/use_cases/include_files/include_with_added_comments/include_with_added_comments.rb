require_relative '../include_use_case'

class IncludeWithAddedComments < IncludeUseCase

  def self.build

    use_case_name = File.basename(__FILE__, '.rb')
    use_case = self.new(use_case_name)

    include_command = IncludeUseCase.construct_include_command(INCLUDER_FILE_NAME, INCLUDED_FILE_NAME, pristine = false)
    use_case.commands_to_execute.push(include_command)

    use_case.files_to_write.store(
        TEMPLATE_FILE_NAME,
        <<EOT
### Include with Added Comments

By default (that is, without option ```--pristine```) file inclusion adds comments that:

* Identify the includer file.
* Identify each includee file.

#### Includee File

@[markdown](#{INCLUDEE_FILE_NAME})

#### Includer File

@[markdown](#{INCLUDER_FILE_NAME})

#### CLI

You can use the command-line interface to perform the inclusion.

##### Command

```sh
markdown_helper include #{INCLUDER_FILE_NAME} #{INCLUDED_FILE_NAME}
```

#### API

You can use the API to perform the inclusion.

##### Ruby Code

```ruby
require 'markdown_helper'

markdown_helper = MarkdownHelper.new
markdown_helper.include(#{INCLUDER_FILE_NAME}, #{INCLUDED_FILE_NAME})
```

#### File with Inclusion and Added Comments

@[markdown](#{INCLUDED_FILE_NAME})

The file path for the included file is relative to the .git directory.
EOT

    )

    use_case.build

  end

end
