### Include Highlighted Code

Use file inclusion to include text as highlighted code.

#### File to Be Included

Here's a file containing code to be included:

@[markdown](hello.rb)

#### Includer File

Here's a template file that includes it:

@[markdown](includer.md)

The treatment token ```ruby``` specifies that the included text is to be highlighted as Ruby code.

#### Command

Here's the command to perform the inclusion:

```sh
markdown_helper include --pristine includer.md included.md
```

@[:markdown](../../pristine.md)

#### File with Inclusion

Here's the finished file with the included highlighted code:

@[:pre](included.md)

And here's the finished markdown, as rendered on this page:

---

@[:markdown](included.md)

---
