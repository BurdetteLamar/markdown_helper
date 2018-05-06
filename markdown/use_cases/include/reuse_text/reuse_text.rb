require_relative '../include_use_case'

class ReuseText < IncludeUseCase

  def self.build

    use_case = self.new('reuse_text')
    use_case.write_includee_file
    use_case.write_includer_file
    use_case.write_ruby_file(pristine = true)

    File.write(
        TEMPLATE_FILE_NAME,
        <<EOT
### Reuse Text

Use file inclusion to stay DRY (Don't Repeat Yourself).

Maintain reusable text in a separate file, then include it wherever it's needed.

#### File To Be Included

@[markdown](#{INCLUDEE_FILE_NAME})

#### Includer File

@[markdown](#{INCLUDER_FILE_NAME})

The treatment token ```:markdown``` specifies that the included text is to be treated as more markdown.

#### CLI

You can use the command-line interface to perform the inclusion.

##### Command

```sh
#{INCLUDE_COMMAND}
```

@[:markdown](../../pristine.md)

#### API

You can use the API to perform the inclusion.

##### Ruby Code

@[ruby](#{RUBY_FILE_NAME})

##### Command

```sh
#{RUBY_COMMAND}
```

#### File with Inclusion

Here's the output file, after inclusion.

@[markdown](#{INCLUDED_FILE_NAME})
EOT
    )

    use_case.build

  end

end
