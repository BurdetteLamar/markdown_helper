<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE README.template.md -->
# Markdown Helper

![Gem Version](https://badge.fury.io/rb/markdown_helper.svg) [Visit gem markdown_helper](https://rubygems.org/gems/markdown_helper)

## Deprecated

- Method ```:resolve```.
- Command ```markdown_helper resolve```.

## What's New?

Page TOC:

- Support is added for creating the table of contents for a markdown page.
- The TOC is a tree of links to the headers on the page, suitable for inclusion with the page itself.
- See the [use case](markdown/use_cases/tables_of_contents/create_and_include_page_toc/use_case.md#create-and-include-page-toc).

## What's a Markdown Helper?

Class <code>MarkdownHelper</code> supports:

* [File inclusion](#file-inclusion): to include text from other files, as code-block or markdown.
* [Page TOC](#page-toc): to create the table of contents for a markdown page.
* [Image path resolution](#image-path-resolution): to resolve relative image paths to absolute URL paths (so they work even in gem documentation). [Deprecated]**
* [Image attributes](#image-attributes): image attributes are passed through to an HTML <code>img</code> tag.  [Deprecated]**

## How It Works

The markdown helper is a preprocessor that reads a markdown document (template) and writes another markdown document.

The template can contain certain instructions that call for file inclusions and image resolutions.

### Restriction:  ```git``` Only

The helper works only in a ```git``` project:  the working directory or one of ita parents must be a git directory -- one in which command ```git rev-parse --git-dir``` succeeds.

### Commented or Pristine?

By default, the output markdown has added comments that show:

* The path to the template file.
* The path to each included file.
* The image description (original) for each resolved image file path.  [Deprecated]**

You can suppress those comments using the <code>pristine</code> option.

## File Inclusion 

<img src="images/include.png" alt="include_icon" width="50">

This markdown helper enables file inclusion in GitHub markdown.

(Actually, this README file itself is built using file inclusion.)

Use the markdown helper to merge external files into a markdown (</code>.md</code>) file.

See the [use cases](markdown/use_cases/use_cases.md#use-cases).

### Merged Text Formats

#### Highlighted Code Block

<!-- >>>>>> BEGIN INCLUDED FILE (ruby): SOURCE markdown/readme/include.rb -->
```include.rb```:
```ruby
class RubyCode
  def initialize
    raise RuntimeError.new('I am only an example!')
  end
end
```
<!-- <<<<<< END INCLUDED FILE (ruby): SOURCE markdown/readme/include.rb -->

#### Plain Code Block

<!-- >>>>>> BEGIN INCLUDED FILE (code_block): SOURCE markdown/readme/include.rb -->
```include.rb```:
```
class RubyCode
  def initialize
    raise RuntimeError.new('I am only an example!')
  end
end
```
<!-- <<<<<< END INCLUDED FILE (code_block): SOURCE markdown/readme/include.rb -->

[Note:  In the gem documentation, RubyDoc.info chooses to highlight this code block regardless.  Go figure.]

#### Comment

Comment text is written into the output between the comment delimiters <code>\<!--</code> and <code>--></code>

#### Markdown

Markdown text is included unadorned, and will be processed on GitHub as markdown.

The markdown text is itself scanned for nested includes.

### Usage

#### CLI

<!-- >>>>>> BEGIN INCLUDED FILE (code_block): SOURCE bin/usage/include.txt -->
```include.txt```:
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
<!-- <<<<<< END INCLUDED FILE (code_block): SOURCE bin/usage/include.txt -->

#### API

<!-- >>>>>> BEGIN INCLUDED FILE (ruby): SOURCE markdown/readme/include_usage.rb -->
```include_usage.rb```:
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
<!-- <<<<<< END INCLUDED FILE (ruby): SOURCE markdown/readme/include_usage.rb -->

#### Include Descriptions

Specify each file inclusion at the beginning of a line via an *include description*, which has the form:

<code>@[</code>*format*<code>]\(</code>*relative_file_path*<code>)</code>

where:

* *format* (in square brackets) is one of the following:
  * Highlighting mode such as <code>[ruby]</code>, to include a highlighted code block.  This can be any Ace mode mentioned in [GitHub Languages](https://github.com/github/linguist/blob/master/lib/linguist/languages.yml).
  * <code>[:code_block]</code>, to include a plain code block.
  * <code>[:markdown]</code>, to include text markdown (to be rendered as markdown).
* *relative_file_path* points to the file to be included.

##### Example Include Descriptions

<!-- >>>>>> BEGIN INCLUDED FILE (code_block): SOURCE markdown/readme/include.md -->
```include.md```:
```code_block
@[ruby](my_ruby.rb)

@[:code_block](my_language.xyzzy)

@[:markdown](my_markdown.md)
```
<!-- <<<<<< END INCLUDED FILE (code_block): SOURCE markdown/readme/include.md -->

## Page TOC

The markdown helper can create the table of contents for a markdown page.
- The TOC is a tree of links to the headers on the page, suitable for inclusion with the page itself.
- See the [use case](markdown/use_cases/tables_of_contents/create_and_include_page_toc/use_case.md#create-and-include-page-toc).



## Image Path Resolution **[Deprecated]**

<img src="images/image.png" alt="image_icon" width="50">

This markdown helper enables image path resolution in GitHub markdown.

(Actually, this README file itself is built using image path resolution.)

Use the markdown helper to resolve image relative paths in a markdown (</code>.md</code>) file.

This matters because when markdown becomes part of a Ruby gem, its images will have been relocated in the documentation at RubyDoc.info, breaking the relative paths. The resolved (absolute) urls, however, will still be valid.

### Usage

#### CLI

<!-- >>>>>> BEGIN INCLUDED FILE (code_block): SOURCE bin/usage/resolve.txt -->
```resolve.txt```:
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
<!-- <<<<<< END INCLUDED FILE (code_block): SOURCE bin/usage/resolve.txt -->

#### API

<!-- >>>>>> BEGIN INCLUDED FILE (ruby): SOURCE markdown/readme/resolve_usage.rb -->
```resolve_usage.rb```:
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
<!-- <<<<<< END INCLUDED FILE (ruby): SOURCE markdown/readme/resolve_usage.rb -->

#### Image Descriptions

Specify each image  at the beginning of a line via an *image description*, which has the form:

<code>![*alt_text*]\(</code>*relative_file_path* <code>|</code> *attributes*<code>)</code>

where:

* *alt_text* is the usual alt text for an HTML image.
* *relative_file_path* points to the file to be included.
* *attributes* specify image attributes.  See [Image Attributes](#image-attributes) below.

##### Example Image Descriptions

<!-- >>>>>> BEGIN INCLUDED FILE (code_block): SOURCE markdown/readme/resolve.md -->
```resolve.md```:
```code_block
![my_alt](image/image.png)

![my_alt](image/image.png | width=50)

![my_alt](image/image.png| width=50 height=50)
```
<!-- <<<<<< END INCLUDED FILE (code_block): SOURCE markdown/readme/resolve.md -->

## Image Attributes

<img src="images/html.png" alt="html_icon" width="50">

This markdown helper enables HTML image attributes in GitHub markdown [image descriptions](https://github.github.com/gfm/#image-description).

(Actually, this README file itself is built using image attributes.)

Use the markdown helper to add image attributes in a markdown (</code>.md</code>) file.

### Usage

#### CLI

<!-- >>>>>> BEGIN INCLUDED FILE (code_block): SOURCE bin/usage/resolve.txt -->
```resolve.txt```:
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
<!-- <<<<<< END INCLUDED FILE (code_block): SOURCE bin/usage/resolve.txt -->

#### API

<!-- >>>>>> BEGIN INCLUDED FILE (ruby): SOURCE markdown/readme/resolve_usage.rb -->
```resolve_usage.rb```:
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
<!-- <<<<<< END INCLUDED FILE (ruby): SOURCE markdown/readme/resolve_usage.rb -->

#### Image Descriptions

Specify each image at the beginning of a line  via an *image description*, which has the form:

<code>![*alt_text*]\(</code>*relative_file_path* <code>|</code> *attributes*<code>)</code>

where:

* *alt_text* is the usual alt text for an HTML image.
* *relative_file_path* points to the file to be included.
* *attributes* are whitespace-separated name-value pairs in the form *name*<code>=</code>*value*.  These are passed through to the generated <code>img</code> HTML element.

##### Example Image Descriptions

<!-- >>>>>> BEGIN INCLUDED FILE (code_block): SOURCE markdown/readme/resolve.md -->
```resolve.md```:
```code_block
![my_alt](image/image.png)

![my_alt](image/image.png | width=50)

![my_alt](image/image.png| width=50 height=50)
```
<!-- <<<<<< END INCLUDED FILE (code_block): SOURCE markdown/readme/resolve.md -->

## What Should Be Next?

I have opened some enhancement Issues in the GitHub [markdown_helper](https://github.com/BurdetteLamar/markdown_helper) project:

* [Project TOC](https://github.com/BurdetteLamar/markdown_helper/issues/37):  table of contents of all markdown pages in project.
* [Partial file inclusion](https://github.com/BurdetteLamar/markdown_helper/issues/38):  including only specified lines from a file (instead of the whole file).
* [Ruby-entity inclusion](https://github.com/BurdetteLamar/markdown_helper/issues/39):  like file inclusion, but including a Ruby class, module, or method.
* [Pagination](https://github.com/BurdetteLamar/markdown_helper/issues/40):  series of markdown pages connected by prev/next navigation links.

Feel free to comment on any of these, or to add more Issues (enhancement or otherwise).
<!-- <<<<<< END GENERATED FILE (include): SOURCE README.template.md -->
