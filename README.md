# MarkdownHelper

## Include Files

<img src="/images/include.png" width="150">

This helper enables file inclusion in GitHub markdown, with code highlighting.

It lets you turn this:
____
```
This code will be in a code block, and will be highlighted.

[include_file](../include/foo.xml)
```
____
into this:
____
This code will be in a code block, and will be highlighted.

File <code>foo.xml</code>:
```xml
<root>
  <element attribute="value">
    <sub_element>
      This included file is XML.
    </sub_element>
  </element>
</root>
```
____
By default:
 
  * Highlighting is provided for Ruby and XML.  Your program can add other file types.
  * Text in an ```.md``` file is not disturbed, and falls through for ordinary markdown rendering.
  * Any other included text is made into a code block, without highlighting.
  
## Usage

```ruby
require 'markdown_helper'

markdown_helper = MarkdownHelper.new
markdown_helper.include('template.md', 'markdown.md')
```

where ```template.md``` may contain file inclusions, and ```markdown.md``` is the finished markdown with the files included.

To add highlighting for an additional file type:

```ruby
markdown_helper = MarkdownHelper.new(:py => 'python')
```

To add warning ```<!--- GENERATED FILE, DO NOT EDIT --->``` to each output file:

```ruby
markdown_helper.tag_as_generated
```
