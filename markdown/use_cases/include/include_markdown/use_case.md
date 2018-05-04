<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE use_case_template.md -->
### Include Markdown

Use file inclusion to include markdown.  The whole page, includer and includee, will be rendered when it's pushed to GitHub.

#### File to Be Included

Here's a file containing markdown to be included:

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./markdown.md -->
```markdown.md```:
```markdown
This fiie, to be included, is markdown.

### This is a level-three title.

Here's a [link](http://yahoo.com).

This is an unordered list:
* One.
* Two.
* Three.
```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./markdown.md -->

#### Includer File

Here's a template file that includes it:

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./includer.md -->
```includer.md```:
```markdown
This file includes the markdown file.

@[:markdown](markdown.md)

```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./includer.md -->

The treatment token ```:markdown``` specifies that the included text is to be treated as markdown.

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
This file includes the markdown file.

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./markdown.md -->
This fiie, to be included, is markdown.

### This is a level-three title.

Here's a [link](http://yahoo.com).

This is an unordered list:
* One.
* Two.
* Three.
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./markdown.md -->

<!-- <<<<<< END GENERATED FILE (include): SOURCE includer.md -->
```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./included.md -->

And here's the finished markdown, as rendered on this page:

---

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./markdown.md -->
This fiie, to be included, is markdown.

### This is a level-three title.

Here's a [link](http://yahoo.com).

This is an unordered list:
* One.
* Two.
* Three.
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./markdown.md -->

---
<!-- <<<<<< END GENERATED FILE (include): SOURCE use_case_template.md -->
