### Reuse Text

Use file inclusion to stay DRY (Don't Repeat Yourself).

Maintain reusable text in a separate file, then include it wherever it's needed.

#### File to Be Included

Here's a file containing some text that can be included:

@[markdown](reusable_text.md)

#### Includer File

Here's a template file that includes it:

@[markdown](includer.md)

#### Command

Here's the command to perform the inclusion:

```sh
markdown_helper include includer.md included.md
```

@[:markdown](../../pristine.md)

#### File with Inclusion

Here's the finished file with the inclusion:

@[markdown](included.md)
