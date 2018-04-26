### Use Case: Reuse Text

Use file inclusion to stay DRY (Don't Repeat Yourself).

Maintain reusable text in a separate file, then include it wherever it's needed.

#### File to Be Included

Here's a file containing some text that can be included:

@[:code_block](reusable_text.md)

#### Includer File

Here's a template file that includes it:

@[:code_block](includer.md)

#### Command

Here's the command to perform the inclusion (```--pristine``` suppresses inclusion comments):

```sh
markdown_helper include --pristine includer.md included.md
```

#### File with Inclusion

Here's the finished file with the inclusion:

@[:code_block](included.md)
