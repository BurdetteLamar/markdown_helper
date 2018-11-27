### Include Page TOC

Use file inclusion to include a page table of contents (page TOC).

The page TOC is a tree of links:

- Each link goes to a corresponding markdown title.
- The tree structure reflects the relative depths of the linked headers.

Below are files to be included and an includer file that will generate the page TOC.

Note that all file inclusion (even nested inclusions) will be performed before the page TOC is build, so the page TOC covers all the included material.

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
