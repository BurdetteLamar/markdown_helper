### Include with Added Comments

By default (that is, without option ```--pristine```) file inclusion adds comments that:

* Identify the includer file.
* Identify the includee file.

#### Includee File

<code>includee.md</code>
```markdown
Text to be included.
```

#### Includer File

<code>includer.md</code>
```markdown
This file includes the text.

@[:verbatim](includee.md)

```

#### Inclusion Command

```sh
markdown_helper include includer.md included.md
```

#### File with Inclusion and Added Comments

<code>included.md</code>
```markdown
<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE includer.md -->
This file includes the text.

<!-- >>>>>> BEGIN INCLUDED FILE (verbatim): SOURCE ./includee.md -->
Text to be included.
<!-- <<<<<< END INCLUDED FILE (verbatim): SOURCE ./includee.md -->

<!-- <<<<<< END GENERATED FILE (include): SOURCE includer.md -->
```
