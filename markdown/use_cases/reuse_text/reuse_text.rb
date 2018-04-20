#!/usr/bin/env ruby

require_relative '../use_case'

class ReuseText < UseCase

  REUSABLE_TEXT_FILE_NAME = 'reusable_text.md'

  def build

    template = <<EOT
### Reusable Text

Use file inclusion to stay DRY (Don't Repeat Yourself).

Maintain reusable text in a separate file, then include it wherever it's needed.

#### File to Include

Here's a file containing some text that can be included in more than one place:

@[:code_block](#{REUSABLE_TEXT_FILE_NAME})

#### Includer File

Here's a template file that includes it:

@[:code_block](#{INCLUDER_FILE_NAME})

#### Command

Here's the command to perform the inclusion (```--pristine``` suppresses inclusion comments):

```sh
#{INCLUDE_COMMAND}
```

#### File with Inclusion

Here's the finished file with the inclusion:

@[:code_block](#{INCLUDED_FILE_NAME})
EOT

    reusable_text = <<EOT
This is some useful text that can be included in more than one place (actually, in more than one file).
EOT

    includer = <<EOT
This file includes the useful text.

@[:verbatim](#{REUSABLE_TEXT_FILE_NAME})
EOT

    write_files(
        REUSABLE_TEXT_FILE_NAME => reusable_text,
        INCLUDER_FILE_NAME => includer,
    )

    # Perform the inclusion.
    system(INCLUDE_COMMAND)

    build_use_case_markdown(template)

  end
end

ReuseText.new.build
