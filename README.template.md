# MarkdownHelper

## Highlighted Include Files

<kbd>
  <img src="/images/include.png" width="50">
</kbd>

This helper enables file inclusion in GitHub markdown, with code highlighting.

Using it, you can turn this:

@[:code_block](test/includes/ruby.rb)

into this:

@[:verbatim](test/actual/ruby_included_ruby.md)

By default:
 
  * Highlighting is provided for file types ```.rb``` (Ruby) and ```.xml``` (XML}.  Your program can add other file types.
  * Text from a markdown file (extension ```.md```) is included verbatim, with no code block or highlighting.
  * Any other included file is made into a code block, but not highlighted.
  
## Usage

In the code below, file ```template.md``` may contain file inclusions, and file ```markdown.md``` is the output markdown with the files included.

@[ruby](examples/usage/usage.rb)

