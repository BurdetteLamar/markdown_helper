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

#### Ruby File

```include.rb```:
```ruby
require 'markdown_helper'

markdown_helper = MarkdownHelper.new(:pristine => true)
markdown_helper.include('includer.md', 'included.md')
```

#### Command

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
