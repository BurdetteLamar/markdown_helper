# MarkdownHelper

## File Inclusion

This helper supports markdown file inclusion in GitHub markdown files, with code highlighting.

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
  




