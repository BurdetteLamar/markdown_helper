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

```diagnose_missing_includee.err```:
```
include.rb: Could not read include file, (MarkdownHelper::MissingIncludeeError)
  Backtrace (innermost include first):
    Level 0:
      Includer:
        Location: markdown/use_cases/include/diagnose_missing_includee/includer_2.md:1
        Include description: @[:markdown](includer_3.md)
      Includee:
        File path: markdown/use_cases/include/diagnose_missing_includee/includer_3.md
    Level 1:
      Includer:
        Location: markdown/use_cases/include/diagnose_missing_includee/includer_1.md:1
        Include description: @[:markdown](includer_2.md)
      Includee:
        File path: markdown/use_cases/include/diagnose_missing_includee/includer_2.md
    Level 2:
      Includer:
        Location: markdown/use_cases/include/diagnose_missing_includee/includer_0.md:1
        Include description: @[:markdown](includer_1.md)
      Includee:
        File path: markdown/use_cases/include/diagnose_missing_includee/includer_1.md
    Level 3:
      Includer:
        Location: includer.md:1
        Include description: @[:markdown](includer_0.md)
      Includee:
        File path: markdown/use_cases/include/diagnose_missing_includee/includer_0.md
```
