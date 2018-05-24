require_relative '../include_use_case'

class IncludeCodeBlock < IncludeUseCase

  def self.build

    use_case_name = File.basename(__FILE__, '.rb')
    use_case = self.new(use_case_name)

    includee_file_name = 'hello.rb'

    use_case.files_to_write.store(
        includee_file_name,
        <<EOT
class HelloWorld
   def initialize(name)
      @name = name.capitalize
   end
   def sayHi
      puts "Hello #{@name}!"
   end
end
EOT
    )

    use_case.files_to_write.store(
        INCLUDER_FILE_NAME,
        <<EOT
This file includes the code as a code block.

@[:code_block](#{includee_file_name})

EOT
    )

    use_case.files_to_write.store(
        TEMPLATE_FILE_NAME,
        <<EOT
### Include a Code Block

Use file inclusion to include text as a code block.

#### File to Be Included

Here's a file containing code to be included:

@[markdown](#{includee_file_name})

#### Includer File

Here's a template file that includes it:

@[markdown](#{INCLUDER_FILE_NAME})

The treatment token ```:code_block``` specifies that the included text is to be treated as a code block.

#### Command

Here's the command to perform the inclusion:

```sh
#{INCLUDE_COMMAND}
```

@[:markdown](../../pristine.md)

#### File with Inclusion

Here's the finished file with the included code block:

@[:pre](#{INCLUDED_FILE_NAME})

And here's the finished markdown, as rendered on this page:

---

@[:markdown](#{INCLUDED_FILE_NAME})

---
EOT
    )

    use_case.build

  end

end
