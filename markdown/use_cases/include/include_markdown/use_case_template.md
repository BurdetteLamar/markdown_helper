### Include Markdown

Use file inclusion to include markdown.  The whole page, includer and includee, will be rendered when it's pushed to GitHub.

#### File to Be Included

Here's a file containing markdown to be included:

@[markdown](markdown.md)

#### Includer File

Here's a template file that includes it:

@[markdown](includer.md)

The treatment token ```:markdown``` specifies that the included text is to be treated as markdown.

#### Command

Here's the command to perform the inclusion:

```sh
markdown_helper include --pristine includer.md included.md
```

@[:markdown](../../pristine.md)

#### File with Inclusion

Here's the finished file with the inclusion:

@[markdown](included.md)

And here's the included markdown, as rendered on this page:

---

@[:markdown](markdown.md)

---
