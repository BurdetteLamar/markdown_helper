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
 
  * Highlighted code blocks are supported for Ruby and XML.  Your program can add others.
  * Text in an ```.md``` file is not disturbed, and falls through for ordinary markdown rendering.
  * Any other included text is made into a code block, without highlighting.
  
## Usage

```ruby
require 'markdown_helper'

template_file_path = 'template.md'
markdown_file_path = 'markdown.md'

markdown_helper = MarkdownHelper.new
markdown_helper.include(template_file_path, markdown_file_path)
```

Template file, ```template.md```:
```
Show some highlighted Ruby code:

[include_file](include.rb)
```
File to be included, ```include.rb```:
```ruby
def hello
 puts 'Hello!'
end
```
The output file, ```markdown.md``` (rendered as markdown):

Show some highlighted Ruby code:

File <code>include.rb</code>:
```ruby
def hello
 puts 'Hello!'
end
```



