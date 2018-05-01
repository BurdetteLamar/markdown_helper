require_relative '../../use_case'

class IncludeWithAddedComments < UseCase

  def self.build

    use_case_dir_path = File.absolute_path(File.dirname(__FILE__))

    use_case = self.new(use_case_dir_path)

    includee_file_name = 'includee.md'
    includer_file_name = 'includer.md'
    included_file_name = 'included.md'

    include_command = use_case.construct_include_command(includer_file_name, included_file_name)
    build_command = use_case.construct_include_command(TEMPLATE_FILE_NAME, USE_CASE_FILE_NAME, pristine = true)

    use_case.commands_to_execute.push(
        include_command,
        build_command,
    )

    use_case.files_to_write.store(
        includee_file_name,
        <<EOT
Text to be included.
EOT
    )

    use_case.files_to_write.store(
        includer_file_name,
        <<EOT
@[:markdown](#{includee_file_name})
EOT
    )

    use_case.files_to_write.store(
        TEMPLATE_FILE_NAME,
        <<EOT
### Include with Added Comments

By default (that is, without option ```--pristine```) file inclusion adds comments that:

* Identify the includer file.
* Identify each includee file.

#### Includee File

@[markdown](#{includee_file_name})

#### Includer File

@[markdown](#{includer_file_name})

#### Inclusion Command

```sh
#{include_command}
```

#### File with Inclusion and Added Comments

@[markdown](#{included_file_name})
EOT

    )

    use_case.build

  end

end
