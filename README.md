# MarkdownHelper

## File Inclusion

This helper supports file inclusion in GitHub markdown files, with code highlighting.

[Convenience tip: open link in a new tab using ```Ctrl-click```, close using```Ctrl-w```.]
 
It lets you turn this:

```
[include_file](../include/xml.xml)

# Include XML

[include_file](../include/xml.xml)
```

into markdown with inlined and highlighted code, [thus](test/actual/xml_included.md).

Optionally, you can add a generated-file warning, [thus](test/actual/xml_included_tagged.md).

Highlighting for included code is supported for Ruby and XML (though it's very to extend the support to others).  Other code is included as generic code, without highlighting, [thus](test/actual/python_included.md).



