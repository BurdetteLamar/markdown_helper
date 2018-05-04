require_relative '../../use_case'

class NestInclusions < UseCase

  def self.build

    use_case_dir_path = File.absolute_path(File.dirname(__FILE__))

    use_case = self.new(use_case_dir_path)

    includee_file_name = 'includee.md'
    nested_includee_file_name = 'nested_includee.md'
    includer_file_name = 'includer.md'
    included_file_name = 'included.md'

    include_command = use_case.construct_include_command(includer_file_name, included_file_name, pristine = true)
    build_command = use_case.construct_include_command(TEMPLATE_FILE_NAME, USE_CASE_FILE_NAME, pristine = true)

    use_case.commands_to_execute.push(
        include_command,
        build_command,
    )

    use_case.files_to_write.store(
        includee_file_name,
        <<EOT
Text for inclusion, and a nested inclusion.

@[:markdown](#{nested_includee_file_name})
EOT
    )

    use_case.files_to_write.store(
        nested_includee_file_name,
        <<EOT
Text for nested inclusion.
EOT
    )

    use_case.files_to_write.store(
        includer_file_name,
        <<EOT
File to do nested inclusion.

@[:markdown](#{includee_file_name})
EOT
    )

    use_case.files_to_write.store(
        TEMPLATE_FILE_NAME,
        <<EOT
### Nest Inclusions

An included markdown file can itself include more files.

#### File To Be Included

@[markdown](#{includee_file_name})

#### File For Nested Inclusion

@[markdown](#{nested_includee_file_name})

#### Includer File

@[markdown](#{includer_file_name})

#### Command

```sh
#{include_command}
```

@[:markdown](../../pristine.md)

#### File with Inclusion

Here's the finished file with the inclusion and nested inclusion:

@[markdown](#{included_file_name})
EOT
    )

    use_case.build

  end

end
