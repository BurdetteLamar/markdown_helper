template_file_name = 'template.md'
use_case_file_name = 'use_case.md'

help_text_file_name = 'include_help.txt'
includer_file_name = 'includer.md'
included_file_name = 'included.md'

help_command = "markdown_helper include --help > #{help_text_file_name}"
include_command = 'markdown_helper include --pristine including_file.md include_help.txt'
include_command = "markdown_helper include --pristine #{includer_file_name} #{included_file_name}"
build_command = "markdown_helper include --pristine #{template_file_name} #{use_case_file_name}"
build_command = "markdown_helper include --pristine #{template_file_name} #{use_case_file_name}"



template = <<EOT
### Include Generated Text

Use the markdown helper to include text that is generated at project "build time."

#### Example

In this project, some markdown pages include help text from the project's executables.  At project "build" time, each executable is run with option ```--help```, and the help text is captured in a file.  That file is then included wherever it's needed.

Thus the displayed help text is always up-to-date.

### Command to Generate Help Text

```sh
#{help_command}
```

### Help Text

@[:code_block](#{help_text_file_path})

###

EOT

includer_file = <<EOT
### File to Include Help

@[:code_block](including_file.md)
EOT

