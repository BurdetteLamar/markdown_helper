# MarkdownHelper

## Highlighted Include Files

<kbd>
  <img src="/images/include.png" width="50">
</kbd>

This helper enables file inclusion in GitHub markdown, with code highlighting.

Using it, you can turn this:

@[include](test/includes/ruby.rb|code_block)

into this:

@[include](test/actual/ruby_included_ruby.md)

By default:
 
  * Highlighting is provided for file types ```.rb``` (Ruby) and ```.xml``` (XML}.  Your program can add other file types.
  * Text from a markdown file (extension ```.md```) is included verbatim, with no code block or highlighting.
  * Any other included file is made into a code block, but not highlighted.
  
## Usage

In the code below, file ```template.md``` may contain file inclusions, and file ```markdown.md``` is the output markdown with the files included.

@[include](examples/usage/usage.rb)

