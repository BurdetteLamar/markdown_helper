### Reusable Text

Use file inclusion to stay DRY (Don't Repeat Yourself).

Maintain reusable text in a separate file, then include it wherever it's needed.

#### Separate File

Here's a file containing some text that can be included in more than one place:

<code>reusable_text.md</code>
```
This is some useful text that can be included in more than one place (actually, in more than one file).
```

#### Template File

Here's a template file that includes it:

<code>includer.md</code>
```
This file includes the useful text.

@[:verbatim](reusable_text.md)
```

#### Command

Here's the command to perform the inclusion (```--pristine``` suppresses inclusion comments):

```sh
ruby ../../../bin/include --pristine includer.md included.md
```

#### Included File

Here's the finished file with the inclusion:

<code>included.md</code>
```
This file includes the useful text.

This is some useful text that can be included in more than one place (actually, in more than one file).
```
