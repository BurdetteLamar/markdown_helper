#!/usr/bin/env ruby

use_case_dir_path = File.absolute_path(File.dirname(__FILE__))

includee_file_name = 'includee.md'
includee_file_path = File.join(
    use_case_dir_path,
    includee_file_name,
)

includer_file_name = 'includer.md'
includer_file_path = File.join(
    use_case_dir_path,
    includer_file_name,
)

included_file_name = 'included.md'

use_case_file_name = 'include_with_added_comments.md'
use_case_file_path = File.join(
    use_case_dir_path,
    use_case_file_name,
)

template_file_name = 'template.md'
template_file_path = File.join(
    use_case_dir_path,
    template_file_name,
)

include_command = "markdown_helper include #{includer_file_name} #{included_file_name}"

File.write(
    includee_file_path,
    <<EOT
Text to be included.
EOT
)

File.write(
    includer_file_path,
    <<EOT
This file includes the text.

@[:verbatim](#{includee_file_name})

EOT
)

# Example inclusion.
Dir.chdir(use_case_dir_path) do
  system(include_command)
end

File.write(
    template_file_path,
    <<EOT
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
)

# Build use case.
build_command = "markdown_helper include --pristine #{template_file_path} #{use_case_file_path}"
system(build_command)
