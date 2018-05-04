<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE use_case_template.md -->
### Reuse Text

Use file inclusion to stay DRY (Don't Repeat Yourself).

Maintain reusable text in a separate file, then include it wherever it's needed.

#### File to Be Included

Here's a file containing some text that can be included:

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./reusable_text.md -->
```reusable_text.md```:
```markdown
This is some reusable text that can be included in more than one place (actually, in more than one file).
```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./reusable_text.md -->

#### Includer File

Here's a template file that includes it:

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./includer.md -->
```includer.md```:
```markdown
This file includes the useful text.

@[:markdown](reusable_text.md)

Then includes it again.

@[:markdown](reusable_text.md)
```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./includer.md -->

#### Command

Here's the command to perform the inclusion:

```sh
markdown_helper include includer.md included.md
```

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./../../pristine.md -->
(Option ```--pristine``` suppresses comment insertion.)
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./../../pristine.md -->

#### File with Inclusion

Here's the finished file with the inclusion:

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./included.md -->
```included.md```:
```markdown
<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE includer.md -->
This file includes the useful text.

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./reusable_text.md -->
This is some reusable text that can be included in more than one place (actually, in more than one file).
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./reusable_text.md -->

Then includes it again.

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./reusable_text.md -->
This is some reusable text that can be included in more than one place (actually, in more than one file).
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./reusable_text.md -->
<!-- <<<<<< END GENERATED FILE (include): SOURCE includer.md -->
```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./included.md -->
<!-- <<<<<< END GENERATED FILE (include): SOURCE use_case_template.md -->
