### Include Page TOC

Use file inclusion to include a page table of contents (TOC).

#### Files to Be Included

Here's a file containing markdown to be included:

@[markdown](markdown_0.md)

Here's another:

@[markdown](markdown_1.md)

#### Includer File

Here's a template file that includes them:

@[markdown](includer.md)

The treatment token ```:page_toc``` specifies where the page TOC is to be inserted.

@[:markdown](../interface.md)

#### File with Inclusion

Here's the finished file with the inclusion:

@[markdown](included.md)

And here's the finished markdown, as rendered on this page:

---

@[:markdown](included.md)

---
