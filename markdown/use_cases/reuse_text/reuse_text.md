### Use Case: Reuse Text

Use file inclusion to stay DRY (Don't Repeat Yourself).

Maintain reusable text in a separate file, then include it wherever it's needed.

#### File to Be Included

Here's a file containing some text that can be included:

<code>reusable_text.md</code>
```
This is some useful text that can be included in more than one place (actually, in more than one file).
```

#### Includer File

Here's a template file that includes it:

<code>includer.md</code>
```
This file includes the useful text.

@[:verbatim](reusable_text.md)
```

#### Command

Here's the command to perform the inclusion (```--pristine``` suppresses inclusion comments):

```sh
markdown_helper include includer.md included.md
```

#### File with Inclusion

Here's the finished file with the inclusion:

<code>included.md</code>
```
<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE includer.md -->
This file includes the useful text.

<!-- >>>>>> BEGIN INCLUDED FILE (verbatim): SOURCE ./reusable_text.md -->
This is some useful text that can be included in more than one place (actually, in more than one file).
<!-- <<<<<< END INCLUDED FILE (verbatim): SOURCE ./reusable_text.md -->
<!-- <<<<<< END GENERATED FILE (include): SOURCE includer.md -->
```
