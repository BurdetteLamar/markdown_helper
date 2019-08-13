### Include Text As Details

Use file inclusion to include text as details.

#### File to Be Included

Here's a file containing text to be included:

```details.md```:
```markdown
<summary>My details</summary>
This is a detail.

This is another.
```

#### Includer File

Here's a template file that includes it:

```includer.md```:
```markdown
This file includes the code as details.

@[:details](details.md)
```

The treatment token ```:details``` specifies that the included text is to be treated as details.

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

#### File with Inclusion

Here's the finished file with the included details:

```included.md```:
```markdown
This file includes the code as details.

<details>
<summary>My details</summary>
This is a detail.

This is another.

</details>
```

And here are the included details, as rendered on this page.:

---

This file includes the code as details.

<details>
<summary>My details</summary>
This is a detail.

This is another.

</details>

