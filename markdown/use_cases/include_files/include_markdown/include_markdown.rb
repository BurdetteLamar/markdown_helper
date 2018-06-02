require_relative '../include_use_case'

class IncludeMarkdown < IncludeUseCase

  def self.build

    use_case_name = File.basename(__FILE__, '.rb')
    use_case = self.new(use_case_name)

    includee_file_name = 'markdown.md'

    use_case.files_to_write.store(
        includee_file_name,
        <<EOT
This fiie, to be included, is markdown.

### This is a level-three title.

Here's a [link](http://yahoo.com).

This is an unordered list:
* One.
* Two.
* Three.
EOT
    )

    use_case.files_to_write.store(
        INCLUDER_FILE_NAME,
        <<EOT
This file includes the markdown file.

@[:markdown](#{includee_file_name})

EOT
    )

    use_case.files_to_write.store(
        TEMPLATE_FILE_NAME,
        <<EOT
### Include Markdown

Use file inclusion to include markdown.  The whole page, includer and includee, will be rendered when it's pushed to GitHub.

#### File to Be Included

Here's a file containing markdown to be included:

@[markdown](#{includee_file_name})

#### Includer File

Here's a template file that includes it:

@[markdown](#{INCLUDER_FILE_NAME})

The treatment token ```:markdown``` specifies that the included text is to be treated as markdown.

@[:markdown](../interface.md)

#### File with Inclusion

Here's the finished file with the inclusion:

@[markdown](#{INCLUDED_FILE_NAME})

And here's the finished markdown, as rendered on this page:

---

@[:markdown](#{includee_file_name})

---
EOT
    )

    use_case.build

  end

end
