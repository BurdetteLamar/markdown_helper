require_relative '../../use_case'

include UseCase

use_case_dir_path = File.absolute_path(File.dirname(__FILE__))

Dir.chdir(use_case_dir_path) do
  includee_file_name = 'includee.md'
  text= <<EOT
Text to be included.
EOT
  write_file(includee_file_name, text)

  includer_file_name = 'includer.md'
  text = <<EOT
@[:markdown](#{includee_file_name})
EOT
  write_file(includer_file_name, text)

  included_file_name = 'included.md'
  include_command = include_command(includer_file_name, included_file_name)
  system(include_command)

  text = <<EOT
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
  write_file(template_file_name, text)

  build_use_case
end
