### Include Markdown

Use file inclusion to include markdown.  The whole page, includer and includee, will be rendered when it's pushed to GitHub.

#### File to Be Included

Here's a file containing markdown to be included:

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

#### Includer File

Here's a template file that includes it:

```includer.md```:
```markdown
This file includes the markdown file.

@[:markdown](markdown.md)

```

The treatment token ```:markdown``` specifies that the included text is to be treated as markdown.

#### CLI

You can use the command-line interface to perform the inclusion.

##### Command

```sh
markdown_helper include --pristine includer.md included.md
```

(Option ```--pristine``` suppresses comment insertion.)

#### API

You can use the API to perform the inclusion.

##### Ruby Code

```include.rb```:
```ruby
require 'markdown_helper'

# Option :pristine suppresses comment insertion.
markdown_helper = MarkdownHelper.new(:pristine => true)
markdown_helper.include('includer.md', 'included.md')
```

##### Command

```sh
ruby include.rb
```

#### File with Inclusion

Here's the finished file with the inclusion:

```included.md```:
```markdown
This file includes the markdown file.

This fiie, to be included, is markdown.

### This is a level-three title.

Here's a [link](http://yahoo.com).

This is an unordered list:
* One.
* Two.
* Three.

```

And here's the finished markdown, as rendered on this page:

---

This fiie, to be included, is markdown.

### This is a level-three title.

Here's a [link](http://yahoo.com).

This is an unordered list:
* One.
* Two.
* Three.

---
