# MarkdownHelper

## File Inclusion  <img src="https://raw.githubusercontent.com/BurdetteLamar/MarkdownHelper/master/images/include.png" width="50">

This markdown helper enables file inclusion in GitHub markdown.

(Actually this README file is built using the file inclusion.)

You can use it to merge external files into a markdown (</code>.md</code>) file.

### Formats

The merged text can be highlighted in a code block:

@[ruby](include.rb)

or plain in a code block:

@[:code_block](include.rb)

or verbatim (which GitHub renders however it likes).

[Note:  RubyDoc.info chooses to highlight both code blocks above.  Go figure.]

### Usage

#### CLI

@[:code_block](../bin/usage/include.txt)

#### API

@[ruby](usage.rb)

#### Include Pragmas

An include pragma has the form:

<code>@[</code>*format*<code>](</code>*relative_file_path*<code>)</code>

where:

* *format* (in square brackets) is one of the following:
  * Highlighting mode such as <code>[ruby]</code>, to include a highlighted code block.  This can be any Ace mode mentioned in [GitHub Languages](https://github.com/github/linguist/blob/master/lib/linguist/languages.yml).
  * <code>[:code_block]</code>, to include a plain code block.
  * <code>[:verbatim]</code>, to include text verbatim (to be rendered as markdown).
* *relative_file_path* points to the file to be included.

##### Examples

@[verbatim](include.md)


