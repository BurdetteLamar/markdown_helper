<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE readme_files/temp_resolved.md -->
<!-- >>>>>> BEGIN GENERATED FILE (resolve): SOURCE readme_files/README.template.md -->
# MarkdownHelper

[![Gem Version](https://badge.fury.io/rb/markdown_helper.svg)](https://badge.fury.io/rb/markdown_helper)

Class <code>MarkdownHelper</code> supports:

* [File inclusion](#file-inclusion): to include text from other files, as code-block or markdown.
* [Image path resolution](#image-path-resolution): to resolve relative image paths to absolute URL paths (so they work even in gem documentation).
* [Image attributes](#image-attrubutes): image attributes are passed through to an HTML <code>img</code> tag.

Next feature:

* "Slide deck": to chain markdown pages into a series with next/prev navigation links.

## File Inclusion 

<img src="https://raw.githubusercontent.com/BurdetteLamar/MarkdownHelper/master/images/include.png" alt="include_icon" width="50">

This markdown helper enables file inclusion in GitHub markdown.

(Actually, this README file itself is built using file inclusion.)

Use the markdown helper to merge external files into a markdown (</code>.md</code>) file.

### Merged Text Formats

#### Highlighted Code Block

<!-- >>>>>> BEGIN INCLUDED FILE: SOURCE readme_files/include.rb -->
<code>include.rb</code>
```ruby
class RubyCode
  def initialize
    raise RuntimeError.new('I am only an example!')
  end
end
```
<!-- <<<<<< END INCLUDED FILE: SOURCE readme_files/include.rb -->

#### Plain Code Block

<!-- >>>>>> BEGIN INCLUDED FILE: SOURCE readme_files/include.rb -->
<code>include.rb</code>
```
class RubyCode
  def initialize
    raise RuntimeError.new('I am only an example!')
  end
end
```
<!-- <<<<<< END INCLUDED FILE: SOURCE readme_files/include.rb -->

[Note:  In the gem documentation, RubyDoc.info chooses to highlight this code block regardless.  Go figure.]

#### Verbatim

Verbatim text is included unadorned.  Most often, verbatim text is markdown to be rendered as part of the markdown page.

### Usage

#### CLI

<!-- >>>>>> BEGIN INCLUDED FILE: SOURCE readme_files/../bin/usage/include.txt -->
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
<!-- <<<<<< END INCLUDED FILE: SOURCE readme_files/../bin/usage/include.txt -->

#### API

<!-- >>>>>> BEGIN INCLUDED FILE: SOURCE readme_files/include_usage.rb -->
<code>include_usage.rb</code>
```ruby
require 'markdown_helper'

markdown_helper = MarkdownHelper.new
template_file_path = 'highlight_ruby_template.md'
markdown_file_path = 'highlighted_ruby.md'
markdown_helper.include(template_file_path, markdown_file_path)
```
<!-- <<<<<< END INCLUDED FILE: SOURCE readme_files/include_usage.rb -->

#### Include Descriptions

Specify each file inclusion at the beginning of a line via an *include description*, which has the form:

<code>@[</code>*format*<code>]\(</code>*relative_file_path*<code>)</code>

where:

* *format* (in square brackets) is one of the following:
  * Highlighting mode such as <code>[ruby]</code>, to include a highlighted code block.  This can be any Ace mode mentioned in [GitHub Languages](https://github.com/github/linguist/blob/master/lib/linguist/languages.yml).
  * <code>[:code_block]</code>, to include a plain code block.
  * <code>[:verbatim]</code>, to include text verbatim (to be rendered as markdown).
* *relative_file_path* points to the file to be included.

##### Example Include Descriptions

<!-- >>>>>> BEGIN INCLUDED FILE: SOURCE readme_files/include.md -->
<code>include.md</code>
```code_block
@[ruby](my_ruby.rb)

@[:code_block](my_language.xyzzy)

@[:verbatim](my_markdown.md)
```
<!-- <<<<<< END INCLUDED FILE: SOURCE readme_files/include.md -->

## Image Path Resolution 

<img src="https://raw.githubusercontent.com/BurdetteLamar/MarkdownHelper/master/images/image.png" alt="image_icon" width="50">

This markdown helper enables image path resolution in GitHub markdown.

(Actually, this README file itself is built using image path resolution.)

Use the markdown helper to resolve image relative paths in a markdown (</code>.md</code>) file.

This matters because when markdown becomes part of a Ruby gem, its images will have been relocated in the documentation at RubyDoc.info, breaking the relative paths. The resolved (absolute) urls, however, will still be valid.

### Usage

#### CLI

<!-- >>>>>> BEGIN INCLUDED FILE: SOURCE readme_files/../bin/usage/resolve.txt -->
<code>resolve.txt</code>
```
Usage:

  resolve template_file_path markdown_file_page

  where

    * template_file_path is the path to an existing file.
    * markdown_file_path is the path to a file to be created.

  Typically:

    * Both file types are .md.
    * The template file contains image relative file paths.  See README.md.
```
<!-- <<<<<< END INCLUDED FILE: SOURCE readme_files/../bin/usage/resolve.txt -->

#### API

<!-- >>>>>> BEGIN INCLUDED FILE: SOURCE readme_files/resolve_usage.rb -->
<code>resolve_usage.rb</code>
```ruby
require 'markdown_helper'

markdown_helper = MarkdownHelper.new
template_file_path = 'template.md'
markdown_file_path = 'markdown.md'
markdown_helper.resolve(template_file_path, markdown_file_path)
```
<!-- <<<<<< END INCLUDED FILE: SOURCE readme_files/resolve_usage.rb -->

#### Image Descriptions

Specify each image  at the beginning of a line via an *image description*, which has the form:

<code>![*alt_text*]\(</code>*relative_file_path* <code>|</code> *attributes*<code>)</code>

where:

* *alt_text* is the usual alt text for an HTML image.
* *relative_file_path* points to the file to be included.
* *attributes* specify image attributes.  See [Image Attributes](#image-attributes) below.

##### Example Image Descriptions

<!-- >>>>>> BEGIN INCLUDED FILE: SOURCE readme_files/resolve.md -->
<code>resolve.md</code>
```code_block
![my_alt](image/image.png)

![my_alt](image/image.png | width=50)

![my_alt](image/image.png| width=50 height=50)
```
<!-- <<<<<< END INCLUDED FILE: SOURCE readme_files/resolve.md -->

## Image Attributes

<img src="https://raw.githubusercontent.com/BurdetteLamar/MarkdownHelper/master/images/html.png" alt="html_icon" width="50">

This markdown helper enables HTML image attributes in GitHub markdown [image descriptions](https://github.github.com/gfm/#image-description).

(Actually, this README file itself is built using image attributes.)

Use the markdown helper to add image attributes in a markdown (</code>.md</code>) file.

### Usage

#### CLI

<!-- >>>>>> BEGIN INCLUDED FILE: SOURCE readme_files/../bin/usage/resolve.txt -->
<code>resolve.txt</code>
```
Usage:

  resolve template_file_path markdown_file_page

  where

    * template_file_path is the path to an existing file.
    * markdown_file_path is the path to a file to be created.

  Typically:

    * Both file types are .md.
    * The template file contains image relative file paths.  See README.md.
```
<!-- <<<<<< END INCLUDED FILE: SOURCE readme_files/../bin/usage/resolve.txt -->

#### API

<!-- >>>>>> BEGIN INCLUDED FILE: SOURCE readme_files/resolve_usage.rb -->
<code>resolve_usage.rb</code>
```ruby
require 'markdown_helper'

markdown_helper = MarkdownHelper.new
template_file_path = 'template.md'
markdown_file_path = 'markdown.md'
markdown_helper.resolve(template_file_path, markdown_file_path)
```
<!-- <<<<<< END INCLUDED FILE: SOURCE readme_files/resolve_usage.rb -->

#### Image Descriptions

Specify each image at the beginning of a line  via an *image description*, which has the form:

<code>![*alt_text*]\(</code>*relative_file_path* <code>|</code> *attributes*<code>)</code>

where:

* *alt_text* is the usual alt text for an HTML image.
* *relative_file_path* points to the file to be included.
* *attributes* are whitespace-separated name-value pairs in the form *name*<code>=</code>*value*.  These are passed through to the generated <code>img</code> HTML element.

##### Example Image Descriptions

<!-- >>>>>> BEGIN INCLUDED FILE: SOURCE readme_files/resolve.md -->
<code>resolve.md</code>
```code_block
![my_alt](image/image.png)

![my_alt](image/image.png | width=50)

![my_alt](image/image.png| width=50 height=50)
```
<!-- <<<<<< END INCLUDED FILE: SOURCE readme_files/resolve.md -->

<!-- <<<<<< END GENERATED FILE (resolve): SOURCE readme_files/README.template.md -->
<!-- <<<<<< END GENERATED FILE (include): SOURCE readme_files/temp_resolved.md -->
