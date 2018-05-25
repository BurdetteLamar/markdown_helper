### Nest Inclusions

An included markdown file can itself include more files.

#### File To Be Included

```includee.md```:
```markdown
Text for inclusion, and a nested inclusion.

@[:markdown](nested_includee.md)
```

#### File For Nested Inclusion

```nested_includee.md```:
```markdown
Text for nested inclusion.
```

#### Includer File

```includer.md```:
```markdown
File to do nested inclusion.

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

Here's the finished file with the inclusion and nested inclusion:

```included.md```:
```markdown
File to do nested inclusion.

Text for inclusion, and a nested inclusion.

Text for nested inclusion.
```
