require_relative '../include_use_case'

class IncludePageToc < IncludeUseCase

  def self.build

    use_case = self.new

    include_command = IncludeUseCase.construct_include_command(INCLUDER_FILE_NAME, INCLUDED_FILE_NAME, pristine = false)
    use_case.commands_to_execute.unshift(include_command)

    includee_0_file_name = 'markdown_0.md'
    includee_1_file_name = 'markdown_1.md'

    use_case.files_to_write.store(
        includee_0_file_name,
        <<EOT
        
## Includee 0 level-two title.

### Includee 0 level-three title.

### Another includee 0 level-three title.

## Another includee 0 level-two title.
EOT
    )

    use_case.files_to_write.store(
        includee_1_file_name,
        <<EOT
        
## Includee 1 level-two title.

### Includee 1 level-three title.

### Another includee 1 level-three title.

## Another includee 1 level-two title.
EOT
    )

    use_case.files_to_write.store(
        INCLUDER_FILE_NAME,
        <<EOT
# Page Title

@[:page_toc](## Page Contents)

## Includer level-two title.

### Includer level-three title.

### Another includer level-three title.

## Another includer level-two title.

@[:markdown](#{includee_0_file_name})

@[:markdown](#{includee_1_file_name})

EOT
    )

    use_case.files_to_write.store(
        TEMPLATE_FILE_NAME,
        <<EOT
### Include Page TOC

Use file inclusion to include a page table of contents (page TOC).

The page TOC is a tree of links:

- Each link goes to a corresponding markdown title.
- The tree structure reflects the relative depths of the linked headers.

Below are files to be included and an includer file that will generate the page TOC.

Note that all file inclusion (even nested inclusions) will be performed before the page TOC is built, so the page TOC covers all the included material.

#### Files to Be Included

Here's a file containing markdown to be included:

@[markdown](#{includee_0_file_name})

Here's another:

@[markdown](#{includee_1_file_name})

#### Includer File

Here's a template file that includes them:

@[markdown](#{INCLUDER_FILE_NAME})

The treatment token ```:page_toc``` specifies where the page TOC is to be inserted.

@[:markdown](../interface.md)

#### File with Inclusion

Here's the finished file with the inclusion:

@[markdown](#{INCLUDED_FILE_NAME})

And here's the finished markdown, as rendered on this page:

---

@[:markdown](#{INCLUDED_FILE_NAME})

---
EOT
    )

    use_case.build

  end

end
