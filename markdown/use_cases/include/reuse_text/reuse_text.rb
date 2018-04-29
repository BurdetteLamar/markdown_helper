#!/usr/bin/env ruby

use_case_dir_path = File.absolute_path(File.dirname(__FILE__))

reusable_text_file_name = 'reusable_text.md'
reusable_text_file_path = File.join(
    use_case_dir_path,
    reusable_text_file_name,
)

includer_file_name = 'includer.md'
includer_file_path = File.join(
    use_case_dir_path,
    includer_file_name,
)

included_file_name = 'included.md'

use_case_file_name = 'reuse_text.md'
use_case_file_path = File.join(
    use_case_dir_path,
    use_case_file_name,
)

template_file_name = 'template.md'
template_file_path = File.join(
    use_case_dir_path,
    template_file_name,
)

include_command = "markdown_helper include --pristine #{includer_file_name} #{included_file_name}"

File.write(
    reusable_text_file_path,
    <<EOT
This is some reusable text that can be included in more than one place (actually, in more than one file).
EOT
)


File.write(
    includer_file_path,
    <<EOT
This file includes the useful text.

@[:verbatim](#{reusable_text_file_name})

Then includes it again.

@[:verbatim](#{reusable_text_file_name})
EOT
)

# Example inclusion.
Dir.chdir(use_case_dir_path) do
  system(include_command)
end

File.write(
    template_file_path,
    <<EOT
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

@[:verbatim](../../pristine.md)

#### File with Inclusion

Here's the finished file with the inclusion:

@[markdown](#{included_file_name})
EOT
)

# Build use case.
build_command = "markdown_helper include --pristine #{template_file_path} #{use_case_file_path}"
system(build_command)
