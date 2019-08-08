### Include Text As Pre

Use file inclusion to include text as pre-formatted (rather than as a code block).

You might need to do this if you have text to include that has triple-backticks.

#### File to Be Included

Here's a file containing text to be included; the text has triple-backticks.:

```triple_backtick.md```:
```markdown
This file uses triple-backtick to format a ```symbol```, which means that it cannot be included as a code block.
```

#### Includer File

Here's a template file that includes it:

```includer.md```:
```markdown
This file includes the backticked content as pre(formatted).

@[:pre](triple_backtick.md)
```

The treatment token ```:pre``` specifies that the included text is to be treated as pre-formatted.

#### Including
<details>
<summary>CLI</summary>
You can use the command-line interface to perform the inclusion.

##### Command

```sh
markdown_helper include --pristine includer.md included.md
```

(Option ```--pristine``` suppresses comment insertion.)
</details>
<details>
<summary>API</summary>
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
</details>

#### File with Inclusion

Here's the finished file with the included preformatted text:

```included.md```:
```markdown
This file includes the backticked content as pre(formatted).

<pre>
This file uses triple-backtick to format a ```symbol```, which means that it cannot be included as a code block.
</pre>
```

