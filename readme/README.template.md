# MarkdownHelper <img src="/images/include.png" width="50">

This helper enables file inclusion in GitHub markdown.

You can use it to merge external files into a markdown (```.md```) file.

The merged text can be highlighted in a code block:

@[ruby](include.rb)

or plain in a code block:

@[:code_block](include.rb)

or verbatim (which GitHub renders however it likes).

## Usage

### Including Files in Markdown

@[verbatim](include.md)

Each inclusion line:

* Starts with ```@```.
* Has a *treatment* in square brackets, one of:
  * A language name such as ```ruby'```, to include a highlighted code block.  This can be any ```ace_mode``` mentioned in [GitHub Languages](https://github.com/github/linguist/blob/master/lib/linguist/languages.yml).
  * ```:code_block```, to include a plain code block.
  * ```:verbatim```, to include text verbatim (to be rendered as markdown).
* Has a relative file path in parentheses, pointing to the file to be included.

### Including the Files

@[ruby](usage.rb)
