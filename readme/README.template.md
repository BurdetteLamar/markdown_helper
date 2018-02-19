# MarkdownHelper

## File Inclusion  <img src="/images/include.png" width="50">

This markdown helper enables file inclusion in GitHub markdown.

(Actually this README file is built using the file inclusion.)

You can use it to merge external files into a markdown (```.md```) file.

The merged text can be highlighted in a code block:

@[ruby](include.rb)

or plain in a code block:

@[:code_block](include.rb)

or verbatim (which GitHub renders however it likes).

### Usage

#### Specify Include Files with Pragmas

@[verbatim](include.md)

An inclusion pragma has the form:

```@[```*treatment*```](```*relative_file_path*```)```

where:

* *treatment* (in square brackets) is one of the following:
  * Highlighting mode such as ```[ruby]```, to include a highlighted code block.  This can be any Ace mode mentioned in [GitHub Languages](https://github.com/github/linguist/blob/master/lib/linguist/languages.yml).
  * ```[:code_block]```, to include a plain code block.
  * ```[:verbatim]```, to include text verbatim (to be rendered as markdown).
* *relative_file_path* points to the file to be included.

#### Include the Files with ```MarkdownHelper#include```

@[ruby](usage.rb)
