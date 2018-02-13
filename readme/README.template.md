# MarkdownHelper

<kbd>
  <img src="/images/include.png" width="50">
</kbd>

This helper enables file inclusion in GitHub markdown.

You can use it to merge external files into a markdown (```.md```) file.

The merged text can be highlighted in a code block:

@[ruby](include.rb)

or plain in a code block:

@[:code_block](include.rb)

or verbatim (which GitHub renders however it likes):

@[:verbatim](include.rb)

## Usage

@[ruby](usage.rb)
