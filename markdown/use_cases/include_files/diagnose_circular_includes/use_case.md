### Diagnose Circular Includes

Use the backtrace of inclusions to diagnose and correct circular inclusions:  that is inclusions that directly or indirectly cause a file to include itself.

#### Files To Be Included

These files demonstrate nested inclusion, with circular inclusions.

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
@[:markdown](includer_0.md)
```

#### Includer File

This file initiates the nested inclusions.

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

Here's the resulting backtrace of inclusions.

```diagnose_circular_includes.err```:
```
C:/Ruby25-x64/lib/ruby/gems/2.5.0/gems/markdown_helper-2.1.0/bin/_include: Includes are circular: (MarkdownHelper::CircularIncludeError)
  Backtrace (innermost include first):
    Level 0:
      Includer:
        Location: markdown/use_cases/include_files/diagnose_circular_includes/includer_2.md:1
        Include description: @[:markdown](includer_0.md)
      Includee:
        File path: markdown/use_cases/include_files/diagnose_circular_includes/includer_0.md
    Level 1:
      Includer:
        Location: markdown/use_cases/include_files/diagnose_circular_includes/includer_1.md:1
        Include description: @[:markdown](includer_2.md)
      Includee:
        File path: markdown/use_cases/include_files/diagnose_circular_includes/includer_2.md
    Level 2:
      Includer:
        Location: markdown/use_cases/include_files/diagnose_circular_includes/includer_0.md:1
        Include description: @[:markdown](includer_1.md)
      Includee:
        File path: markdown/use_cases/include_files/diagnose_circular_includes/includer_1.md
    Level 3:
      Includer:
        Location: includer.md:1
        Include description: @[:markdown](includer_0.md)
      Includee:
        File path: markdown/use_cases/include_files/diagnose_circular_includes/includer_0.md
```
