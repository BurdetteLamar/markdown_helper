require_relative '../include_use_case'

class IncludeHighlightedCode < IncludeUseCase

  def self.build

    use_case = self.new

    use_case.write_includer_file

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

Here's a file containing Ruby code to be included:

@[markdown](#{includee_file_name})

#### Includer File

Here's a template file that includes it:

@[markdown](#{INCLUDER_FILE_NAME})

The treatment token ```ruby``` specifies that the included text is to be highlighted as Ruby code.

The treatment token can be any Ace mode mentioned in [GitHub Languages](https://github.com/github/linguist/blob/master/lib/linguist/languages.yml).  The file lists about 100 Ace modes, covering just about every language and format.

@[:markdown](../interface.md)

#### File with Inclusion

Here's the finished file with the included highlighted code:

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
