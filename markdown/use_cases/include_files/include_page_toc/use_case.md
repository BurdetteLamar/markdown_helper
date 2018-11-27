### Include Page TOC

Use file inclusion to include a page table of contents (page TOC).

The page TOC is a tree of links:

- Each link goes to a corresponding markdown title.
- The tree structure reflects the relative depths of the linked headers.

Below are files to be included and an includer file that will generate the page TOC.

Note that all file inclusion (even nested inclusions) will be performed before the page TOC is build, so the page TOC covers all the included material.

#### Files to Be Included

Here's a file containing markdown to be included:

```markdown_0.md```:
```markdown
        
## Includee 0 level-two title.

### Includee 0 level-three title.

### Another includee 0 level-three title.

## Another includee 0 level-two title.
```

Here's another:

```markdown_1.md```:
```markdown
        
## Includee 1 level-two title.

### Includee 1 level-three title.

### Another includee 1 level-three title.

## Another includee 1 level-two title.
```

#### Includer File

Here's a template file that includes them:

```includer.md```:
```markdown
# Page Title

@[:page_toc](## Page Contents)

## Includer level-two title.

### Includer level-three title.

### Another includer level-three title.

## Another includer level-two title.

@[:markdown](markdown_0.md)

@[:markdown](markdown_1.md)

```

The treatment token ```:page_toc``` specifies where the page TOC is to be inserted.

#### CLI

You can use the command-line interface to perform the inclusion.

##### Command

```sh
markdown_helper include --pristine includer.md included.md
```

(Option ```--pristine``` suppresses comment insertion.)

#### API

You can use the API to perform the inclusion.

##### Ruby Code

```include.rb```:
```ruby
require 'markdown_helper'

# Option :pristine suppresses comment insertion.
markdown_helper = MarkdownHelper.new(:pristine => true)
markdown_helper.include('includer.md', 'included.md')
```

##### Command

```sh
ruby include.rb
```

#### File with Inclusion

Here's the finished file with the inclusion:

```included.md```:
```markdown
<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE includer.md -->
# Page Title

## Page Contents
- [Includer level-two title.](#includer-level-two-title)
  - [Includer level-three title.](#includer-level-three-title)
  - [Another includer level-three title.](#another-includer-level-three-title)
- [Another includer level-two title.](#another-includer-level-two-title)
- [Includee 0 level-two title.](#includee-0-level-two-title)
  - [Includee 0 level-three title.](#includee-0-level-three-title)
  - [Another includee 0 level-three title.](#another-includee-0-level-three-title)
- [Another includee 0 level-two title.](#another-includee-0-level-two-title)
- [Includee 1 level-two title.](#includee-1-level-two-title)
  - [Includee 1 level-three title.](#includee-1-level-three-title)
  - [Another includee 1 level-three title.](#another-includee-1-level-three-title)
- [Another includee 1 level-two title.](#another-includee-1-level-two-title)

## Includer level-two title.

### Includer level-three title.

### Another includer level-three title.

## Another includer level-two title.

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE markdown/use_cases/include_files/include_page_toc/markdown_0.md -->
        
## Includee 0 level-two title.

### Includee 0 level-three title.

### Another includee 0 level-three title.

## Another includee 0 level-two title.
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE markdown/use_cases/include_files/include_page_toc/markdown_0.md -->

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE markdown/use_cases/include_files/include_page_toc/markdown_1.md -->
        
## Includee 1 level-two title.

### Includee 1 level-three title.

### Another includee 1 level-three title.

## Another includee 1 level-two title.
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE markdown/use_cases/include_files/include_page_toc/markdown_1.md -->

<!-- <<<<<< END GENERATED FILE (include): SOURCE includer.md -->
```

And here's the finished markdown, as rendered on this page:

---

<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE includer.md -->
# Page Title

## Page Contents
- [Includer level-two title.](#includer-level-two-title)
  - [Includer level-three title.](#includer-level-three-title)
  - [Another includer level-three title.](#another-includer-level-three-title)
- [Another includer level-two title.](#another-includer-level-two-title)
- [Includee 0 level-two title.](#includee-0-level-two-title)
  - [Includee 0 level-three title.](#includee-0-level-three-title)
  - [Another includee 0 level-three title.](#another-includee-0-level-three-title)
- [Another includee 0 level-two title.](#another-includee-0-level-two-title)
- [Includee 1 level-two title.](#includee-1-level-two-title)
  - [Includee 1 level-three title.](#includee-1-level-three-title)
  - [Another includee 1 level-three title.](#another-includee-1-level-three-title)
- [Another includee 1 level-two title.](#another-includee-1-level-two-title)

## Includer level-two title.

### Includer level-three title.

### Another includer level-three title.

## Another includer level-two title.

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE markdown/use_cases/include_files/include_page_toc/markdown_0.md -->
        
## Includee 0 level-two title.

### Includee 0 level-three title.

### Another includee 0 level-three title.

## Another includee 0 level-two title.
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE markdown/use_cases/include_files/include_page_toc/markdown_0.md -->

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE markdown/use_cases/include_files/include_page_toc/markdown_1.md -->
        
## Includee 1 level-two title.

### Includee 1 level-three title.

### Another includee 1 level-three title.

## Another includee 1 level-two title.
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE markdown/use_cases/include_files/include_page_toc/markdown_1.md -->

<!-- <<<<<< END GENERATED FILE (include): SOURCE includer.md -->

---
