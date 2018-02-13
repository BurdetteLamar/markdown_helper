# MarkdownHelper

<kbd>
  <img src="/images/include.png" width="50">
</kbd>

This helper enables file inclusion in GitHub markdown.

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

or verbatim (which GitHub renders however it likes):

class RubyCode
  def initialize
    raise RuntimeError.new('I am only an example!')
  end
end

## Usage

<code>usage.rb</code>
```ruby
require 'markdown_helper'

markdown_helper = MarkdownHelper.new
template_file_path = 'highlight_ruby_template.md'
markdown_file_path = 'highlighted_ruby.rb'
markdown_helper.include(template_file_path, markdown_file_path)
```
