require_relative '../../use_case'

class IncludeViaApi < UseCase

  def self.build

    use_case_dir_path = File.absolute_path(File.dirname(__FILE__))

    use_case = self.new(use_case_dir_path)

    includee_file_name = 'includee.md'
    includer_file_name = 'includer.md'
    included_file_name = 'included.md'
    ruby_file_name = 'include.rb'

    include_command = use_case.construct_include_command(includer_file_name, included_file_name, pristine = true)
    ruby_command = 'ruby include.rb'
    build_command = use_case.construct_include_command(TEMPLATE_FILE_NAME, USE_CASE_FILE_NAME, pristine = true)

    use_case.commands_to_execute.push(
        include_command,
        build_command,
    )

    use_case.files_to_write.store(
        includee_file_name,
        <<EOT
Text in includee file.
EOT
    )

    use_case.files_to_write.store(
        includer_file_name,
        <<EOT
Text in includer file.

@[:markdown](#{includee_file_name})

EOT
    )

    use_case.files_to_write.store(
        ruby_file_name,
        <<EOT
require 'markdown_helper'

markdown_helper = MarkdownHelper.new(:pristine => true)
markdown_helper.include('#{includer_file_name}', '#{included_file_name}')
EOT
    )

    use_case.files_to_write.store(
        TEMPLATE_FILE_NAME,
        <<EOT
### Include Via API

Use Ruby code to include files via the API.

#### File To Be Included

@[markdown](#{includee_file_name})

#### Includer File

@[markdown](#{includer_file_name})

#### CLI

##### Command

Here's the command to perform the inclusion:

```sh
#{include_command}
```

@[:markdown](../../pristine.md)

API

##### Ruby File

@[ruby](#{ruby_file_name})

##### Command

```sh
#{ruby_command}
```

@[:markdown](../../pristine.md)

#### File with Inclusion

@[markdown](#{included_file_name})
EOT
    )

    use_case.build

  end

end
