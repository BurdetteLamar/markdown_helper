### Include with Added Comments

By default (that is, without option ```--pristine```) file inclusion adds comments that:

* Identify the includer file.
* Identify each includee file.

#### Includee File

```includee.md```:
```markdown
Text to be included.
```

#### Includer File

```includer.md```:
```markdown
@[:markdown](includee.md)
```

#### Inclusion Command

```sh
markdown_helper include includer.md included.md
```

#### File with Inclusion and Added Comments

```included.md```:
```markdown
<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE includer.md -->
<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./includee.md -->
Text to be included.
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./includee.md -->
<!-- <<<<<< END GENERATED FILE (include): SOURCE includer.md -->
```
