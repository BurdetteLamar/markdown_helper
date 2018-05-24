require_relative '../include_use_case'

class NestInclusions < IncludeUseCase

  def self.build

    use_case_name = File.basename(__FILE__, 'rb')
    use_case = self.new(use_case_name)

    nested_includee_file_name = 'nested_includee.md'

    use_case.files_to_write.store(
        nested_includee_file_name,
        <<EOT
Text for nested inclusion.
EOT
    )

    use_case.files_to_write.store(
        INCLUDER_FILE_NAME,
        <<EOT
File to do nested inclusion.

@[:markdown](#{INCLUDEE_FILE_NAME})
EOT
    )

    use_case.files_to_write.store(
        TEMPLATE_FILE_NAME,
        <<EOT
### Nest Inclusions

An included markdown file can itself include more files.

#### File To Be Included

@[markdown](#{INCLUDEE_FILE_NAME})

#### File For Nested Inclusion

@[markdown](#{nested_includee_file_name})

#### Includer File

@[markdown](#{INCLUDER_FILE_NAME})

#### Command

```sh
#{INCLUDE_COMMAND}
```

@[:markdown](../../pristine.md)

#### File with Inclusion

Here's the finished file with the inclusion and nested inclusion:

@[markdown](#{INCLUDED_FILE_NAME})
EOT
    )

    use_case.build

  end

end
