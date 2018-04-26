<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE markdown/temp_resolved.md -->
<!-- >>>>>> BEGIN GENERATED FILE (resolve): SOURCE markdown/README.template.md -->
# Markdown Helper

<!-- >>>>>> BEGIN RESOLVED IMAGES: INPUT-LINE '![Gem Version](https://badge.fury.io/rb/markdown_helper.svg) [Visit gem markdown_helper](https://rubygems.org/gems/markdown_helper)
' -->
<img src="https://badge.fury.io/rb/markdown_helper.svg" alt="Gem Version"> [Visit gem markdown_helper](https://rubygems.org/gems/markdown_helper)
<!-- <<<<<< END RESOLVED IMAGES: INPUT-LINE '![Gem Version](https://badge.fury.io/rb/markdown_helper.svg) [Visit gem markdown_helper](https://rubygems.org/gems/markdown_helper)
' -->

## What's New?

Command-line interface is now supported:

* ```markdown_helper include [options] template_file_path markdown_file_path```
* ```markdown_helper resolve [options] template_file_path markdown_file_path```

## What's This?

Class <code>MarkdownHelper</code> supports:

* [File inclusion](#file-inclusion): to include text from other files, as code-block or markdown.
* [Image path resolution](#image-path-resolution): to resolve relative image paths to absolute URL paths (so they work even in gem documentation).
* [Image attributes](#image-attributes): image attributes are passed through to an HTML <code>img</code> tag.

## How It Works

The markdown helper is a preprocessor that reads a markdown document (template) and writes another markdown document.

The template can contain certain instructions that call for file inclusions and image resolutions.

### Commented or Pristine?

By default, the output markdown has added comments that show:

* The path to the template file.
* The path to each included file.
* The image description (original) for each resolved image file path.

You can suppress those comments using the <code>pristine</code> option.

## File Inclusion 

<!-- >>>>>> BEGIN RESOLVED IMAGES: INPUT-LINE '![include_icon](../images/include.png | width=50)
' -->
<img src="https://raw.githubusercontent.com/BurdetteLamar/markdown_helper/master/images/include.png" alt="include_icon" width="50">
<!-- <<<<<< END RESOLVED IMAGES: INPUT-LINE '![include_icon](../images/include.png | width=50)
' -->

This markdown helper enables file inclusion in GitHub markdown.

(Actually, this README file itself is built using file inclusion.)

Use the markdown helper to merge external files into a markdown (</code>.md</code>) file.

### Merged Text Formats

#### Highlighted Code Block

<!-- >>>>>> BEGIN INCLUDED FILE (ruby): SOURCE markdown/include.rb -->
<code>include.rb</code>
```ruby
class RubyCode
  def initialize
    raise RuntimeError.new('I am only an example!')
  end
end
```
<!-- <<<<<< END INCLUDED FILE (ruby): SOURCE markdown/include.rb -->

#### Plain Code Block

<!-- >>>>>> BEGIN INCLUDED FILE (code_block): SOURCE markdown/include.rb -->
<code>include.rb</code>
```
class RubyCode
  def initialize
    raise RuntimeError.new('I am only an example!')
  end
end
```
<!-- <<<<<< END INCLUDED FILE (code_block): SOURCE markdown/include.rb -->

[Note:  In the gem documentation, RubyDoc.info chooses to highlight this code block regardless.  Go figure.]

#### Comment

Comment text is written into the output between the comment delimiters <code>\<!--</code> and <code>--></code>

#### Verbatim

Verbatim text is included unadorned.  Most often, verbatim text is markdown to be rendered as part of the markdown page.

The verbatim text is itself scanned for nested includes.

### Usage

#### CLI

<!-- >>>>>> BEGIN INCLUDED FILE (code_block): SOURCE markdown/../bin/usage/include.txt -->
<code>include.txt</code>
```

Usage: markdown_helper include [options] template_file_path markdown_file_path
        --pristine                   No comments added
        --help                       Display help
    
  where

    * template_file_path is the path to an existing file.
    * markdown_file_path is the path to a file to be created.

  Typically:

    * Both file types are .md.
    * The template file contains file inclusion descriptions.
```
<!-- <<<<<< END INCLUDED FILE (code_block): SOURCE markdown/../bin/usage/include.txt -->

#### API

<!-- >>>>>> BEGIN INCLUDED FILE (ruby): SOURCE markdown/include_usage.rb -->
<code>include_usage.rb</code>
```ruby
require 'markdown_helper'

template_file_path = 'highlight_ruby_template.md'
markdown_file_path = 'highlighted_ruby.md'
markdown_helper = MarkdownHelper.new
markdown_helper.include(template_file_path, markdown_file_path)
# Pristine.
markdown_helper.pristine = true
markdown_helper.include(template_file_path, markdown_file_path)
# Also pristine.
markdown_helper = MarkdownHelper.new(:pristine => true)
markdown_helper.include(template_file_path, markdown_file_path)
```
<!-- <<<<<< END INCLUDED FILE (ruby): SOURCE markdown/include_usage.rb -->

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

<!-- >>>>>> BEGIN INCLUDED FILE (code_block): SOURCE markdown/include.md -->
<code>include.md</code>
```code_block
@[ruby](my_ruby.rb)

@[:code_block](my_language.xyzzy)

@[:verbatim](my_markdown.md)
```
<!-- <<<<<< END INCLUDED FILE (code_block): SOURCE markdown/include.md -->

## Image Path Resolution 

<!-- >>>>>> BEGIN RESOLVED IMAGES: INPUT-LINE '![image_icon](../images/image.png | width=50)
' -->
<img src="https://raw.githubusercontent.com/BurdetteLamar/markdown_helper/master/images/image.png" alt="image_icon" width="50">
<!-- <<<<<< END RESOLVED IMAGES: INPUT-LINE '![image_icon](../images/image.png | width=50)
' -->

This markdown helper enables image path resolution in GitHub markdown.

(Actually, this README file itself is built using image path resolution.)

Use the markdown helper to resolve image relative paths in a markdown (</code>.md</code>) file.

This matters because when markdown becomes part of a Ruby gem, its images will have been relocated in the documentation at RubyDoc.info, breaking the relative paths. The resolved (absolute) urls, however, will still be valid.

### Usage

#### CLI

<!-- >>>>>> BEGIN INCLUDED FILE (code_block): SOURCE markdown/../bin/usage/resolve.txt -->
<code>resolve.txt</code>
```

Usage: markdown_helper resolve [options] template_file_path markdown_file_path
        --pristine                   No comments added
        --help                       Display help
    
  where

    * template_file_path is the path to an existing file.
    * markdown_file_path is the path to a file to be created.

  Typically:

    * Both file types are .md.
    * The template file contains image descriptions.
```
<!-- <<<<<< END INCLUDED FILE (code_block): SOURCE markdown/../bin/usage/resolve.txt -->

#### API

<!-- >>>>>> BEGIN INCLUDED FILE (ruby): SOURCE markdown/resolve_usage.rb -->
<code>resolve_usage.rb</code>
```ruby
require 'markdown_helper'

template_file_path = 'template.md'
markdown_file_path = 'markdown.md'
markdown_helper = MarkdownHelper.new
markdown_helper.resolve(template_file_path, markdown_file_path)
# Pristine.
markdown_helper.pristine = true
markdown_helper.resolve(template_file_path, markdown_file_path)
# Also pristine.
markdown_helper = MarkdownHelper.new(:pristine => true)
markdown_helper.resolve(template_file_path, markdown_file_path)
```
<!-- <<<<<< END INCLUDED FILE (ruby): SOURCE markdown/resolve_usage.rb -->

#### Image Descriptions

Specify each image  at the beginning of a line via an *image description*, which has the form:

<code>![*alt_text*]\(</code>*relative_file_path* <code>|</code> *attributes*<code>)</code>

where:

* *alt_text* is the usual alt text for an HTML image.
* *relative_file_path* points to the file to be included.
* *attributes* specify image attributes.  See [Image Attributes](#image-attributes) below.

##### Example Image Descriptions

<!-- >>>>>> BEGIN INCLUDED FILE (code_block): SOURCE markdown/resolve.md -->
<code>resolve.md</code>
```code_block
![my_alt](image/image.png)

![my_alt](image/image.png | width=50)

![my_alt](image/image.png| width=50 height=50)
```
<!-- <<<<<< END INCLUDED FILE (code_block): SOURCE markdown/resolve.md -->

## Image Attributes

<!-- >>>>>> BEGIN RESOLVED IMAGES: INPUT-LINE '![html_icon](../images/html.png | width=50)
' -->
<img src="https://raw.githubusercontent.com/BurdetteLamar/markdown_helper/master/images/html.png" alt="html_icon" width="50">
<!-- <<<<<< END RESOLVED IMAGES: INPUT-LINE '![html_icon](../images/html.png | width=50)
' -->

This markdown helper enables HTML image attributes in GitHub markdown [image descriptions](https://github.github.com/gfm/#image-description).

(Actually, this README file itself is built using image attributes.)

Use the markdown helper to add image attributes in a markdown (</code>.md</code>) file.

### Usage

#### CLI

<!-- >>>>>> BEGIN INCLUDED FILE (code_block): SOURCE markdown/../bin/usage/resolve.txt -->
<code>resolve.txt</code>
```

Usage: markdown_helper resolve [options] template_file_path markdown_file_path
        --pristine                   No comments added
        --help                       Display help
    
  where

    * template_file_path is the path to an existing file.
    * markdown_file_path is the path to a file to be created.

  Typically:

    * Both file types are .md.
    * The template file contains image descriptions.
```
<!-- <<<<<< END INCLUDED FILE (code_block): SOURCE markdown/../bin/usage/resolve.txt -->

#### API

<!-- >>>>>> BEGIN INCLUDED FILE (ruby): SOURCE markdown/resolve_usage.rb -->
<code>resolve_usage.rb</code>
```ruby
require 'markdown_helper'

template_file_path = 'template.md'
markdown_file_path = 'markdown.md'
markdown_helper = MarkdownHelper.new
markdown_helper.resolve(template_file_path, markdown_file_path)
# Pristine.
markdown_helper.pristine = true
markdown_helper.resolve(template_file_path, markdown_file_path)
# Also pristine.
markdown_helper = MarkdownHelper.new(:pristine => true)
markdown_helper.resolve(template_file_path, markdown_file_path)
```
<!-- <<<<<< END INCLUDED FILE (ruby): SOURCE markdown/resolve_usage.rb -->

#### Image Descriptions

Specify each image at the beginning of a line  via an *image description*, which has the form:

<code>![*alt_text*]\(</code>*relative_file_path* <code>|</code> *attributes*<code>)</code>

where:

* *alt_text* is the usual alt text for an HTML image.
* *relative_file_path* points to the file to be included.
* *attributes* are whitespace-separated name-value pairs in the form *name*<code>=</code>*value*.  These are passed through to the generated <code>img</code> HTML element.

##### Example Image Descriptions

<!-- >>>>>> BEGIN INCLUDED FILE (code_block): SOURCE markdown/resolve.md -->
<code>resolve.md</code>
```code_block
![my_alt](image/image.png)

![my_alt](image/image.png | width=50)

![my_alt](image/image.png| width=50 height=50)
```
<!-- <<<<<< END INCLUDED FILE (code_block): SOURCE markdown/resolve.md -->

## What Should Be Next?

I have opened some enhancement Issues in the GitHub [markdown_helper](https://github.com/BurdetteLamar/markdown_helper) project:

* [File TOC](https://github.com/BurdetteLamar/markdown_helper/issues/36):  table of contents of all headers in a markdown page.
* [Project TOC](https://github.com/BurdetteLamar/markdown_helper/issues/37):  table of contents of all markdown pages in project.
* [Partial file inclusion](https://github.com/BurdetteLamar/markdown_helper/issues/38):  including only specified lines from a file (instead of the whole file).
* [Ruby-entity inclusion](https://github.com/BurdetteLamar/markdown_helper/issues/39):  like file inclusion, but including a Ruby class, module, or method.
* [Pagination](https://github.com/BurdetteLamar/markdown_helper/issues/40):  series of markdown pages connected by prev/next navigation links.

Feel free to comment on any of these, or to add more Issues (enhancement or otherwise).
<!-- <<<<<< END GENERATED FILE (resolve): SOURCE markdown/README.template.md -->
<!-- <<<<<< END GENERATED FILE (include): SOURCE markdown/temp_resolved.md -->
