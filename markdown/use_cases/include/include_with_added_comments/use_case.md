<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE use_case_template.md -->
### Include with Added Comments

By default (that is, without option ```--pristine```) file inclusion adds comments that:

* Identify the includer file.
* Identify each includee file.

#### Includee File

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./includee.md -->
```includee.md```:
```markdown
Text to be included.
```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./includee.md -->

#### Includer File

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./includer.md -->
```includer.md```:
```markdown
@[:markdown](includee.md)
```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./includer.md -->

#### Inclusion Command

```sh
markdown_helper include includer.md included.md
```

#### File with Inclusion and Added Comments

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./included.md -->
```included.md```:
```markdown
<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE includer.md -->
<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./includee.md -->
Text to be included.
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./includee.md -->
<!-- <<<<<< END GENERATED FILE (include): SOURCE includer.md -->
```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./included.md -->
<!-- <<<<<< END GENERATED FILE (include): SOURCE use_case_template.md -->
