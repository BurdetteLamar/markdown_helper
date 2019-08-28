### Diagnose Missing Includee

Use the backtrace of inclusions to diagnose and correct a missing or otherwise unreadable includee file.

The backtrace is especially useful for errors in nested includes.

#### Files To Be Included

These files demonstrate nested inclusion, with a missing includee file.

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

This file initiates the nested inclusions.

```includer.md```:
```markdown
@[:markdown](includer_0.md)
```

#### Include Via <code>markdown_helper</code>
<details>
<summary>CLI</summary>

```sh
markdown_helper include --pristine includer.md included.md
```

(Option ```--pristine``` suppresses comment insertion.)
</details>
<details>
<summary>API</summary>

```include.rb```:
```ruby
require 'markdown_helper'

# Option :pristine suppresses comment insertion.
markdown_helper = MarkdownHelper.new(:pristine => true)
markdown_helper.include('includer.md', 'included.md')
```

</details>

#### Error and Backtrace

Here's the resulting backtrace of inclusions.

```diagnose_missing_includee.err```:
```
C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/markdown_helper-2.3.0/bin/_include: Could not read includee file: (MarkdownHelper::UnreadableIncludeeError)
  Backtrace (innermost include first):
    Level 0:
      Includer:
        Location: markdown/use_cases/include/diagnose_missing_includee/includer_2.md:0
        Include pragma: @[:markdown](includer_3.md)
      Includee:
        File path: markdown/use_cases/include/diagnose_missing_includee/includer_3.md
    Level 1:
      Includer:
        Location: markdown/use_cases/include/diagnose_missing_includee/includer_1.md:0
        Include pragma: @[:markdown](includer_2.md)
      Includee:
        File path: markdown/use_cases/include/diagnose_missing_includee/includer_2.md
    Level 2:
      Includer:
        Location: markdown/use_cases/include/diagnose_missing_includee/includer_0.md:0
        Include pragma: @[:markdown](includer_1.md)
      Includee:
        File path: markdown/use_cases/include/diagnose_missing_includee/includer_1.md
    Level 3:
      Includer:
        Location: markdown/use_cases/include/diagnose_missing_includee/includer.md:0
        Include pragma: @[:markdown](includer_0.md)
      Includee:
        File path: markdown/use_cases/include/diagnose_missing_includee/includer_0.md
```
