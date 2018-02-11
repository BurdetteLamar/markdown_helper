# MarkdownHelper

## File Inclusion

<img src="/images/include.png" width="150">

This helper enables file inclusion in GitHub markdown files, with code highlighting.

It lets you turn this:
____
```
# Markdown Page with XML Included

This code will be in a code block, and will be highlighted.

[include_file](../include/xml.xml)
```
____
into this:
____
# Markdown Page with XML Included

This code will be in a code block, and will be highlighted.

<code>xml.xml</code>
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
  * Markdown code in a ```.md``` file is not disturbed, and falls through for the usual markdown formatting.
  * Any other included code is made into a code block without highlighting.
  
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

<code>include.rb</code>
```ruby
def hello
 puts 'Hello!'
end
```



