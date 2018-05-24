### Include Via API

Use Ruby code to include files via the API.

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

##### Command

Here's the command to perform the inclusion:

```sh
markdown_helper include --pristine includer.md included.md
```

(Option ```--pristine``` suppresses comment insertion.)

API

##### Ruby File

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

(Option ```--pristine``` suppresses comment insertion.)

#### File with Inclusion

```included.md```:
```markdown
Text in includer file.

Text in includee file.

```
