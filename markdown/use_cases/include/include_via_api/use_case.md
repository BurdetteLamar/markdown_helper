<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE use_case_template.md -->
### Include Via API

Use Ruby code to include files via the API.

#### File To Be Included

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./includee.md -->
```includee.md```:
```markdown
Text in includee file.
```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./includee.md -->

#### Includer File

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./includer.md -->
```includer.md```:
```markdown
Text in includer file.

@[:markdown](includee.md)

```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./includer.md -->

#### Ruby File

<!-- >>>>>> BEGIN INCLUDED FILE (ruby): SOURCE ./include.rb -->
```include.rb```:
```ruby
require 'markdown_helper'

markdown_helper = MarkdownHelper.new(:pristine => true)
markdown_helper.include('includer.md', 'included.md')
```
<!-- <<<<<< END INCLUDED FILE (ruby): SOURCE ./include.rb -->

#### Command

```sh
ruby include.rb
```

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./../../pristine.md -->
(Option ```--pristine``` suppresses comment insertion.)
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./../../pristine.md -->

#### File with Inclusion

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./included.md -->
```included.md```:
```markdown
Text in includer file.

Text in includee file.

```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./included.md -->
<!-- <<<<<< END GENERATED FILE (include): SOURCE use_case_template.md -->
