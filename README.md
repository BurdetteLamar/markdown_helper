<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE README.template.md -->
# Markdown Helper

[![Gem](https://img.shields.io/gem/v/markdown_helper.svg?style=flat)](http://rubygems.org/gems/markdown_helper "View this project in Rubygems")

### Contents
- [What's New?](#whats-new)
- [What's a Markdown Helper?](#whats-a-markdown-helper)
- [How It Works](#how-it-works)
  - [Restriction: ```git``` Only](#restriction-git-only)
  - [Commented or Pristine?](#commented-or-pristine)
- [File Inclusion ](#file-inclusion-)
  - [Merged Text Formats](#merged-text-formats)
    - [Highlighted Code Block](#highlighted-code-block)
    - [Plain Code Block](#plain-code-block)
    - [Comment](#comment)
    - [Markdown](#markdown)
  - [Usage](#usage)
    - [CLI](#cli)
    - [API](#api)
    - [Include Descriptions](#include-descriptions)
      - [Example Include Descriptions](#example-include-descriptions)
    - [Page TOC](#page-toc)
    - [Diagnostics](#diagnostics)
      - ["Noisy" (Not Pristine)](#noisy-not-pristine)
      - [Missing Includee File](#missing-includee-file)
      - [Circular Inclusion](#circular-inclusion)
- [What Should Be Next?](#what-should-be-next)

## What's New?

Page TOC (table of contents) is improved:

- Before:  you would first run the markdown helper to generate a page TOC, then run the helper a second time to include the page TOC where you want it.
- Now:  you specify the site for the page TOC in the page itself, and the page TOC is automatically generated and inserted there.  See the [use case](markdown/use_cases/include_files/include_page_toc/use_case.md#include-page-toc)

The old way is now deprecated.

## What's a Markdown Helper?

Class <code>MarkdownHelper</code> supports:

* [File inclusion](#file-inclusion): to include text from other files, as code-block or markdown.
* [Page TOC](#page-toc): to create and insert the table of contents for a markdown page.

## How It Works

The markdown helper is a preprocessor that reads a markdown document (template) and writes another markdown document.

The template can contain certain instructions that call for file inclusions.

### Restriction: ```git``` Only

The helper works only in a ```git``` project:  the working directory or one of ita parents must be a git directory -- one in which command ```git rev-parse --git-dir``` succeeds.

### Commented or Pristine?

By default, the output markdown has added comments that show:

* The path to the template file.
* The path to each included file.

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
markdown_helper.pristine = true # Pristine.
markdown_helper.include(template_file_path, markdown_file_path)
markdown_helper = MarkdownHelper.new(:pristine => true) # Also pristine.
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
  * <code>[:comment]</code>, to insert text as a markdown comment.
  * <code>[:pre]</code>, to include pre-formatted text.
* *relative_file_path* points to the file to be included.

##### Example Include Descriptions

<!-- >>>>>> BEGIN INCLUDED FILE (code_block): SOURCE markdown/readme/include.md -->
```include.md```:
```code_block
@[ruby](my_ruby.rb)

@[:code_block](my_language.xyzzy)

@[:markdown](my_markdown.md)

@[:comment](my_comment.txt)

@[:pre](my_preformatted.txt)
```
<!-- <<<<<< END INCLUDED FILE (code_block): SOURCE markdown/readme/include.md -->

#### Page TOC

Specify the location for a page TOC (table of cotents) via a *page TOC description*, which has the form:

<code>@[:page_toc]\(</code>*markdown_header*<code>)</code>

Example:

<code>@[:page_toc]\(### Contents)</code>

#### Diagnostics

##### "Noisy" (Not Pristine)

By default, the markdown helper inserts comments indicating inclusions.

##### Missing Includee File

A missing includee file causes an exception that shows an inclusion backtrace.

##### Circular Inclusion

A circular inclusion causes an exception that shows an inclusion backtrace.

## What Should Be Next?

I have opened some enhancement Issues in the GitHub [markdown_helper](https://github.com/BurdetteLamar/markdown_helper) project:

* [Project TOC](https://github.com/BurdetteLamar/markdown_helper/issues/37):  table of contents of all markdown pages in project.
* [Partial file inclusion](https://github.com/BurdetteLamar/markdown_helper/issues/38):  including only specified lines from a file (instead of the whole file).
* [Ruby-entity inclusion](https://github.com/BurdetteLamar/markdown_helper/issues/39):  like file inclusion, but including a Ruby class, module, or method.
* [Pagination](https://github.com/BurdetteLamar/markdown_helper/issues/40):  series of markdown pages connected by prev/next navigation links.

Feel free to comment on any of these, or to add more Issues (enhancement or otherwise).
<!-- <<<<<< END GENERATED FILE (include): SOURCE README.template.md -->
