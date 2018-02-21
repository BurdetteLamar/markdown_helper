# MarkdownHelper

## File Inclusion  <img src="https://raw.githubusercontent.com/BurdetteLamar/MarkdownHelper/master/images/include.png" width="50">

This markdown helper enables file inclusion in GitHub markdown.

(Actually this README file is built using the file inclusion.)

You can use it to merge external files into a markdown (</code>.md</code>) file.

### Merged Text Formats

#### Highlighted Code Block

@[ruby](include.rb)

#### Plain Code Block

@[:code_block](include.rb)

[Note:  For the gem's documentation, RubyDoc.info chooses to highlight this code block regardless.  Go figure.]

#### Verbatim

Verbatim text becomes part of markdown page, and is rendered on GitHub in the usual manner.

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


