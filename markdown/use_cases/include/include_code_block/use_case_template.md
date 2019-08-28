### Include Code Block

Use file inclusion to include text as a code block.

#### File to Be Included

Here's a file containing code to be included:

@[markdown](hello.rb)

#### Includer File

Here's a template file that includes it:

@[markdown](includer.md)

The treatment token ```:code_block``` specifies that the included text is to be treated as a code block.

@[:markdown](../interface.md)

#### File with Inclusion

Here's the finished file with the included code block:

@[:pre](included.md)

And here's the finished markdown, as rendered on this page:

---

@[:markdown](included.md)

---
