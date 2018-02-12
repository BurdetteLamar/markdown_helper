# MarkdownHelper

## Highlighted Include Files

<kbd>
  <img src="/images/include.png" width="50">
</kbd>

This helper enables file inclusion in GitHub markdown, with code highlighting.

Using it, you can turn this:

___
<code>ruby.rb</code>
___
```
class RubyCode

  attr_accessor :foo, :bar

  def initialize(foo, bar)
    puts('This is Ruby.')
  end

end
```
___

into this:

<code>ruby.rb</code>
```ruby
class RubyCode

  attr_accessor :foo, :bar

  def initialize(foo, bar)
    puts('This is Ruby.')
  end

end
```

By default:
 
  * Highlighting is provided for file types ```.rb``` (Ruby) and ```.xml``` (XML}.  Your program can add other file types.
  * Text from a markdown file (extension ```.md```) is included verbatim, with no code block or highlighting.
  * Any other included file is made into a code block, but not highlighted.
  
## Usage

In the code below, file ```template.md``` may contain file inclusions, and file ```markdown.md``` is the output markdown with the files included.

___
<code>usage.rb</code>
___
```ruby
require 'markdown_helper'

# Include files.
markdown_helper = MarkdownHelper.new
markdown_helper.include('template.md', 'markdown.md')

# Enable highlighting for a file type.
markdown_helper.highlight_file_type(:py, 'python')

# Disable highlighting for a file type.
markdown_helper.code_block_file_type(:xml)

# Disable code blocking for a file type.
markdown_helper.verbatim_file_type(:xml)

# Add warning comment ''<!--- GENERATED FILE, DO NOT EDIT --->'' to each output file.
markdown_helper.tag_as_generated = true
```
___

