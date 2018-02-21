[![Gem Version](https://badge.fury.io/rb/markdown_helper.svg)](https://badge.fury.io/rb/markdown_helper)

# MarkdownHelper

## File Inclusion  <img src="https://raw.githubusercontent.com/BurdetteLamar/MarkdownHelper/master/images/include.png" width="50">

This markdown helper enables file inclusion in GitHub markdown.

(Actually, this README file itself is built using file inclusion.)

Use the markdown helper to merge external files into a markdown (</code>.md</code>) file.

### Merged Text Formats

#### Highlighted Code Block

@[ruby](include.rb)

#### Plain Code Block

@[:code_block](include.rb)

[Note:  In the gem documentation, RubyDoc.info chooses to highlight this code block regardless.  Go figure.]

#### Verbatim

Verbatim text is included unadorned.  Most often, verbatim text is markdown to be rendered as part of the markdown page.

### Usage

#### CLI

@[:code_block](../bin/usage/include.txt)

#### API

@[ruby](usage.rb)

#### Include Pragmas

Specify each file inclusion via an *include pragma*, which has the form:

<code>@[format](relative_file_path)</code>

where:

* *format* (in square brackets) is one of the following:
  * Highlighting mode such as <code>[ruby]</code>, to include a highlighted code block.  This can be any Ace mode mentioned in [GitHub Languages](https://github.com/github/linguist/blob/master/lib/linguist/languages.yml).
  * <code>[:code_block]</code>, to include a plain code block.
  * <code>[:verbatim]</code>, to include text verbatim (to be rendered as markdown).
* *relative_file_path* points to the file to be included.

##### Example Include Pragmas

@[verbatim](include.md)


