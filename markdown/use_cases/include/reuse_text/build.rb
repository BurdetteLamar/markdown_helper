require_relative '../../use_case'

include UseCase

use_case_dir_path = File.absolute_path(File.dirname(__FILE__))

build_use_case(use_case_dir_path) do

  reusable_text_file_name = 'reusable_text.md'
  text = <<EOT
This is some reusable text that can be included in more than one place (actually, in more than one file).
EOT
  write_file(reusable_text_file_name, text)

  includer_file_name = 'includer.md'
  text = <<EOT
This file includes the useful text.

@[:markdown](#{reusable_text_file_name})

Then includes it again.

@[:markdown](#{reusable_text_file_name})
EOT
  write_file(includer_file_name, text)

  included_file_name = 'included.md'
  include_command = include_command(includer_file_name, included_file_name, pristine = true)
  system(include_command)

  text = <<EOT
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
  write_file(template_file_name, text)

end
