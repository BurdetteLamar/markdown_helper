reusable_text_file_name = 'reusable_text.md'
includer_file_name = 'includer.md'
included_file_name = 'included.md'
template_file_name = 'template.md'
use_case_file_name = 'use_case.md'

include_command = "markdown_helper include --pristine #{includer_file_name} #{included_file_name}"
build_command = "markdown_helper include --pristine #{template_file_name} #{use_case_file_name}"

template = <<EOT
### Reusable Text

Use file inclusion to stay DRY (Don't Repeat Yourself).

Maintain reusable text in a separate file, then include it wherever it's needed.

#### File to Include

Here's a file containing some text that can be included in more than one place:

@[:code_block](#{reusable_text_file_name})

#### Template File

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

reusable_text = <<EOT
This is some useful text that can be included in more than one place (actually, in more than one file).
EOT

includer = <<EOT
This file includes the useful text.

@[:verbatim](#{reusable_text_file_name})
EOT

# Write markdown files.
{
  template_file_name => template,
  reusable_text_file_name => reusable_text,
  includer_file_name => includer,
}.each_pair do |file_name, text|
  File.write(file_name, text)
end

# Perform the inclusion.
system(include_command)

# Build the use case.
system(build_command)
