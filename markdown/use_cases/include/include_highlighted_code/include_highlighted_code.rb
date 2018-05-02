require_relative '../../use_case'

class IncludeHighlightedCode < UseCase

  def self.build

    use_case_dir_path = File.absolute_path(File.dirname(__FILE__))

    use_case = self.new(use_case_dir_path)

    includee_file_name = 'hello.rb'
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
        includer_file_name,
        <<EOT
This file includes the code as highlighted code.

@[ruby](#{includee_file_name})

EOT
    )

    use_case.files_to_write.store(
        TEMPLATE_FILE_NAME,
        <<EOT
### Include Highlighted Code

Use file inclusion to include text as highlighted code.

#### File to Be Included

Here's a file containing code to be included:

@[markdown](#{includee_file_name})

#### Includer File

Here's a template file that includes it:

@[markdown](#{includer_file_name})

The treatment token ```ruby``` specifies that the included text is to be highlighted as Ruby code.

#### Command

Here's the command to perform the inclusion:

```sh
#{include_command}
```

@[:markdown](../../pristine.md)

#### File with Inclusion

Here's the finished file with the included highlighted code:

@[:pre](#{included_file_name})

And here's the finished markdown, as rendered on this page:

---

@[:markdown](#{included_file_name})

---
EOT
    )

    use_case.build

  end

end
