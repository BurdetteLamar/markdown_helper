### Reuse Text

Use file inclusion to stay DRY (Don't Repeat Yourself).

Maintain reusable text in a separate file, then include it wherever it's needed.

#### File to Be Included

Here's a file containing some text that can be included:

<code>reusable_text.md</code>
```markdown
This is some reusable text that can be included in more than one place (actually, in more than one file).
```

#### Includer File

Here's a template file that includes it:

<code>includer.md</code>
```markdown
This file includes the useful text.

@[:verbatim](reusable_text.md)

Then includes it again.

@[:verbatim](reusable_text.md)
```

#### Command

Here's the command to perform the inclusion:

```sh
markdown_helper include --pristine includer.md included.md
```

(Option ```--pristine``` suppresses comment insertion.)

#### File with Inclusion

Here's the finished file with the inclusion:

<code>included.md</code>
```markdown
This file includes the useful text.

This is some reusable text that can be included in more than one place (actually, in more than one file).

Then includes it again.

This is some reusable text that can be included in more than one place (actually, in more than one file).
```
