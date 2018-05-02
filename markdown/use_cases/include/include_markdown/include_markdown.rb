require_relative '../../use_case'

class IncludeMarkdown < UseCase

  def self.build

    use_case_dir_path = File.absolute_path(File.dirname(__FILE__))

    use_case = self.new(use_case_dir_path)

    includee_file_name = 'markdown.md'
    includer_file_name = 'includer.md'
    included_file_name = 'included.md'

    include_command = use_case.construct_include_command(includer_file_name, included_file_name, pristine = true)
    build_command = use_case.construct_include_command(TEMPLATE_FILE_NAME, USE_CASE_FILE_NAME, pristine = true)

    use_case.commands_to_execute.push(
        include_command,
        build_command,
    )

    use_case.files_to_write.store(
        includee_file_name,
        <<EOT
This fiie, to be included, is markdown.

### This is a level-three title.

Here's a [link](yahoo.com).

This is an unordered list:
* One.
* Two.
* Three.
EOT
    )

    use_case.files_to_write.store(
        includer_file_name,
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

@[markdown](#{includer_file_name})

The treatment token ```:markdown``` specifies that the included text is to be treated as markdown.

#### Command

Here's the command to perform the inclusion:

```sh
#{include_command}
```

@[:markdown](../../pristine.md)

#### File with Inclusion

Here's the finished file with the inclusion:

@[markdown](#{included_file_name})

And here's the included markdown, as rendered on this page:

---

@[:markdown](#{includee_file_name})

---
EOT
    )

    use_case.build

  end

end
