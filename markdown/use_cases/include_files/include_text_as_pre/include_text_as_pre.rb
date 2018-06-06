require_relative '../include_use_case'

class IncludeTextAsPre < IncludeUseCase

  def self.build

    use_case_name = File.basename(__FILE__, '.rb')
    use_case = self.new(use_case_name)

    includee_file_name = 'triple_backtick.md'

    use_case.files_to_write.store(
        includee_file_name,
        <<EOT
This file uses triple-backtick to format a ```symbol```, which means that it cannot be included as a code block.
EOT
    )

    use_case.files_to_write.store(
        INCLUDER_FILE_NAME,
        <<EOT
This file includes the backticked content as pre(formatted).

@[:pre](#{includee_file_name})

EOT
    )

    use_case.files_to_write.store(
        TEMPLATE_FILE_NAME,
        <<EOT
### Include Text As Pre

Use file inclusion to include text as pre-formatted (rather than as a code block).

You might need to do this if you have text to include that has triple-backticks.

#### File to Be Included

Here's a file containing text to be included; the text has triple-backticks.:

@[markdown](#{includee_file_name})

#### Includer File

Here's a template file that includes it:

@[markdown](#{INCLUDER_FILE_NAME})

The treatment token ```:pre``` specifies that the included text is to be treated as pre-formatted.

@[:markdown](../interface.md)

#### File with Inclusion

Here's the finished file with the included preformatted text:

@[markdown](#{INCLUDED_FILE_NAME})

EOT
    )

    system(INCLUDE_COMMAND)

    use_case.build

  end

end
