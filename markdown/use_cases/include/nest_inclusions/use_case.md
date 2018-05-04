<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE use_case_template.md -->
### Nest Inclusions

An included markdown file can itself include more files.

#### File To Be Included

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./includee.md -->
```includee.md```:
```markdown
Text for inclusion, and a nested inclusion.

@[:markdown](nested_includee.md)
```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./includee.md -->

#### File For Nested Inclusion

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./nested_includee.md -->
```nested_includee.md```:
```markdown
Text for nested inclusion.
```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./nested_includee.md -->

#### Includer File

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./includer.md -->
```includer.md```:
```markdown
File to do nested inclusion.

@[:markdown](includee.md)
```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./includer.md -->

#### Command

```sh
markdown_helper include includer.md included.md
```

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./../../pristine.md -->
(Option ```--pristine``` suppresses comment insertion.)
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./../../pristine.md -->

#### File with Inclusion

Here's the finished file with the inclusion and nested inclusion:

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./included.md -->
```included.md```:
```markdown
<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE includer.md -->
File to do nested inclusion.

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./includee.md -->
Text for inclusion, and a nested inclusion.

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./nested_includee.md -->
Text for nested inclusion.
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./nested_includee.md -->
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./includee.md -->
<!-- <<<<<< END GENERATED FILE (include): SOURCE includer.md -->
```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./included.md -->
<!-- <<<<<< END GENERATED FILE (include): SOURCE use_case_template.md -->
