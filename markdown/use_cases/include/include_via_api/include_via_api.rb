require_relative '../include_use_case'

class IncludeViaApi < IncludeUseCase

  def self.build

    use_case_name = File.basename(__FILE__, '.rb')
    use_case = self.new(use_case_name)

    use_case.write_ruby_file(pristine = true)

    use_case.files_to_write.store(
        INCLUDEE_FILE_NAME,
        <<EOT
Text in includee file.
EOT
    )

    use_case.files_to_write.store(
        INCLUDER_FILE_NAME,
        <<EOT
Text in includer file.

@[:markdown](#{INCLUDEE_FILE_NAME})

EOT
    )

    use_case.files_to_write.store(
        TEMPLATE_FILE_NAME,
        <<EOT
### Include Via API

Use Ruby code to include files via the API.

#### File To Be Included

@[markdown](#{INCLUDEE_FILE_NAME})

#### Includer File

@[markdown](#{INCLUDER_FILE_NAME})

#### CLI

##### Command

Here's the command to perform the inclusion:

```sh
#{INCLUDE_COMMAND}
```

@[:markdown](../../pristine.md)

API

##### Ruby File

@[ruby](#{RUBY_FILE_NAME})

##### Command

```sh
#{RUBY_COMMAND}
```

@[:markdown](../../pristine.md)

#### File with Inclusion

@[markdown](#{INCLUDED_FILE_NAME})
EOT
    )

    use_case.build

  end

end
