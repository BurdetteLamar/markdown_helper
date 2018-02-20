# MarkdownHelper

## File Inclusion  <img src="https://raw.githubusercontent.com/BurdetteLamar/MarkdownHelper/master/images/include.png" width="50">

This markdown helper enables file inclusion in GitHub markdown.

(Actually this README file is built using the file inclusion.)

You can use it to merge external files into a markdown (```.md```) file.

The merged text can be highlighted in a code block:

<code>include.rb</code>
```ruby
class RubyCode
  def initialize
    raise RuntimeError.new('I am only an example!')
  end
end
```

or plain in a code block:

<code>include.rb</code>
```
class RubyCode
  def initialize
    raise RuntimeError.new('I am only an example!')
  end
end
```

or verbatim (which GitHub renders however it likes).

[Note:  RubyGems.org chooses to highlight both code blocks above.  Go figure.]

### Usage

#### Specify Include Files with Pragmas

<code>include.md</code>
```verbatim
@[ruby](include.rb)

@[:code_block](include.rb)

@[:verbatim](include.rb)
```

An inclusion pragma has the form:

```@[```*treatment*```](```*relative_file_path*```)```

where:

* *treatment* (in square brackets) is one of the following:
  * Highlighting mode such as ```[ruby]```, to include a highlighted code block.  This can be any Ace mode mentioned in [GitHub Languages](https://github.com/github/linguist/blob/master/lib/linguist/languages.yml).
  * ```[:code_block]```, to include a plain code block.
  * ```[:verbatim]```, to include text verbatim (to be rendered as markdown).
* *relative_file_path* points to the file to be included.


#### Include the Files with ```MarkdownHelper#include```

<code>usage.rb</code>
```ruby
require 'markdown_helper'

markdown_helper = MarkdownHelper.new
template_file_path = 'highlight_ruby_template.md'
markdown_file_path = 'highlighted_ruby.rb'
markdown_helper.include(template_file_path, markdown_file_path)
```
