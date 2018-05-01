require_relative '../../use_case'

include UseCase

use_case_dir_path = File.absolute_path(File.dirname(__FILE__))

build_use_case(use_case_dir_path) do

  includee_file_name = 'includee.md'
  includer_file_name = 'includer.md'
  included_file_name = 'included.md'

  include_command = include_command(includer_file_name, included_file_name)

  includee_text= <<EOT
Text to be included.
EOT
  write_file(includee_file_name, includee_text)

  includer_text = <<EOT
@[:markdown](#{includee_file_name})
EOT
  write_file(includer_file_name, includer_text)

  template_text = <<EOT
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
  write_file(template_file_name, template_text)

  system(include_command)

end
