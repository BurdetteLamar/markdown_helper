# MarkdownHelper

## File Inclusion  <img src="https://raw.githubusercontent.com/BurdetteLamar/MarkdownHelper/master/images/include.png" width="50">

This markdown helper enables file inclusion in GitHub markdown.

(Actually, this README file itself is built using file inclusion.)

Use the markdown helper to merge external files into a markdown (</code>.md</code>) file.

### Merged Text Formats

#### Highlighted Code Block

<code>include.rb</code>
```ruby
class RubyCode
  def initialize
    raise RuntimeError.new('I am only an example!')
  end
end
```

#### Plain Code Block

<code>include.rb</code>
```
class RubyCode
  def initialize
    raise RuntimeError.new('I am only an example!')
  end
end
```

[Note:  In the gem documentation, RubyDoc.info chooses to highlight this code block regardless.  Go figure.]

#### Verbatim

Verbatim text is included unadorned.  Most often, verbatim text is markdown to be rendered as part of the markdown page.

### Usage

#### CLI

<code>include.txt</code>
```
Usage:

  include template_file_path markdown_file_page

  where

    * template_file_path is the path to an existing file.
    * markdown_file_path is the path to a file to be created.

  Typically:

    * Both file types are .md.
    * The template file contains file inclusion pragmas.  See README.md.
```

#### API

<code>usage.rb</code>
```ruby
require 'markdown_helper'

markdown_helper = MarkdownHelper.new
template_file_path = 'highlight_ruby_template.md'
markdown_file_path = 'highlighted_ruby.rb'
markdown_helper.include(template_file_path, markdown_file_path)
```

#### Include Pragmas

Specify each file inclusion via an *include pragma*, which has the form:

<code>@[</code>*format*<code>](</code>*relative_file_path*<code>)</code>

where:

* *format* (in square brackets) is one of the following:
  * Highlighting mode such as <code>[ruby]</code>, to include a highlighted code block.  This can be any Ace mode mentioned in [GitHub Languages](https://github.com/github/linguist/blob/master/lib/linguist/languages.yml).
  * <code>[:code_block]</code>, to include a plain code block.
  * <code>[:verbatim]</code>, to include text verbatim (to be rendered as markdown).
* *relative_file_path* points to the file to be included.

##### Example Include Pragmas

<code>include.md</code>
```verbatim
@[ruby](include.rb)

@[:code_block](include.rb)

@[:verbatim](include.rb)
```


