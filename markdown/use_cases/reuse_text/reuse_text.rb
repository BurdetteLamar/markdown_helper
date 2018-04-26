#!/usr/bin/env ruby

reusable_text_file_name = 'reusable_text.md'
includer_file_name = 'includer.md'
included_file_name = 'included.md'
use_case_file_name = 'reuse_text.md'
template_file_name = 'template.md'

include_command = "markdown_helper include --pristine #{includer_file_name} #{included_file_name}"

File.write(
    reusable_text_file_name,
    <<EOT
This is some useful text that can be included in more than one place (actually, in more than one file).
EOT
)

File.write(
    includer_file_name,
    <<EOT
This file includes the useful text.

@[:verbatim](#{reusable_text_file_name})
EOT
)

# Example inclusion.
system(include_command)

File.write(
    template_file_name,
    <<EOT
### Use Case: Reuse Text

Use file inclusion to stay DRY (Don't Repeat Yourself).

Maintain reusable text in a separate file, then include it wherever it's needed.

#### File to Be Included

Here's a file containing some text that can be included:

@[:code_block](#{reusable_text_file_name})

#### Includer File

Here's a template file that includes it:

@[:code_block](#{includer_file_name})

#### Command

Here's the command to perform the inclusion (```--pristine``` suppresses inclusion comments):

```sh
#{include_command}
```

#### File with Inclusion

Here's the finished file with the inclusion:

@[:code_block](#{included_file_name})
EOT
)

# Build use case.
build_command = "markdown_helper include --pristine #{template_file_name} #{use_case_file_name}"
system(build_command)
