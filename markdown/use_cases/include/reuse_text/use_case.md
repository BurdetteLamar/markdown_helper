### Reuse Text

Use file inclusion to stay DRY (Don't Repeat Yourself).

Maintain reusable text in a separate file, then include it wherever it's needed.

#### File To Be Included

```includee.md```:
```markdown
Text in includee file.
```

#### Includer File

```includer.md```:
```markdown
Text in includer file.

@[:markdown](includee.md)

```

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

Here's the output file, after inclusion.

```included.md```:
```markdown
Text in includer file.

Text in includee file.

```
