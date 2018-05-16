### Diagnose Missing Includee

Use the backtrace of inclusions to diagnose and correct a missing or otherwise unreadable includee file.

The backtrace is especially useful for errors in nested includes.

#### Files To Be Included

```includer_0.md```:
```markdown
@[:markdown](includer_1.md)
```

```includer_1.md```:
```markdown
@[:markdown](includer_2.md)
```

```includer_2.md```:
```markdown
@[:markdown](includer_3.md)
```

#### Includer File

```includer.md```:
```markdown
@[:markdown](includer_0.md)
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

#### Error and Backtrace

```error_and_backtrace.txt```:
```

```
