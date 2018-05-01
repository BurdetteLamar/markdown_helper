require_relative '../../use_case'

class ReuseText < UseCase

  def self.build

    use_case_dir_path = File.absolute_path(File.dirname(__FILE__))

    use_case = self.new(use_case_dir_path)

    reusable_text_file_name = 'reusable_text.md'
    includer_file_name = 'includer.md'
    included_file_name = 'included.md'

    include_command = use_case.construct_include_command(includer_file_name, included_file_name, pristine = true)
    build_command = use_case.construct_include_command(TEMPLATE_FILE_NAME, USE_CASE_FILE_NAME, pristine = true)

    use_case.commands_to_execute.push(
        include_command,
        build_command,
    )

    use_case.files_to_write.store(
        reusable_text_file_name,
        <<EOT
This is some reusable text that can be included in more than one place (actually, in more than one file).
EOT
    )

    use_case.files_to_write.store(
        includer_file_name,
        <<EOT
This file includes the useful text.

@[:markdown](#{reusable_text_file_name})

Then includes it again.

@[:markdown](#{reusable_text_file_name})
EOT
    )

    use_case.files_to_write.store(
        TEMPLATE_FILE_NAME,
        <<EOT
### Reuse Text

Use file inclusion to stay DRY (Don't Repeat Yourself).

Maintain reusable text in a separate file, then include it wherever it's needed.

#### File to Be Included

Here's a file containing some text that can be included:

@[markdown](#{reusable_text_file_name})

#### Includer File

Here's a template file that includes it:

@[markdown](#{includer_file_name})

#### Command

Here's the command to perform the inclusion:

```sh
#{include_command}
```

@[:markdown](../../pristine.md)

#### File with Inclusion

Here's the finished file with the inclusion:

@[markdown](#{included_file_name})
EOT
    )

    use_case.build

  end

end
