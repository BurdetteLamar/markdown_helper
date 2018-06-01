### Create a Table of Contents for a Markdown Page.

1.  Maintain markdown text in a separate file.
2.  Create a table of contents for the text.
3.  Use an includer file to include the contents and the text.

#### Text File

It's big, so linking instead of including:

[text file](text.md)

#### Includer File

### Page Contents
        
  - [Lorem Ipsum](#lorem-ipsum)
    - [Curabitur Tortor](#curabitur-tortor)
      - [Quisque Volutpat](#quisque-volutpat)
      - [Sed Lectus](#sed-lectus)
    - [Curabitur Sit](#curabitur-sit)
      - [Vestibulum Nisi](#vestibulum-nisi)
      - [Sed Cursus](#sed-cursus)

# Lorem Ipsum

Dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. 

## Curabitur Tortor

Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus, iaculis vel, suscipit quis, luctus non, massa. Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. 

### Quisque Volutpat

Cndimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam nec ante. Sed lacinia, urna non tincidunt mattis, tortor neque adipiscing diam, a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. Suspendisse potenti. Nunc feugiat mi a tellus consequat imperdiet. Vestibulum sapien. Proin quam. Etiam ultrices. Suspendisse in justo eu magna luctus suscipit. 

### Sed Lectus

Integer euismod lacus luctus magna. Quisque cursus, metus vitae pharetra auctor, sem massa mattis sem, at interdum magna augue eget diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Morbi lacinia molestie dui. Praesent blandit dolor. Sed non quam. In vel mi sit amet augue congue elementum. Morbi in ipsum sit amet pede facilisis laoreet. Donec lacus nunc, viverra nec, blandit vel, egestas et, augue. Vestibulum tincidunt malesuada tellus. Ut ultrices ultrices enim. 

## Curabitur Sit
 
 Amet mauris. Morbi in dui quis est pulvinar ullamcorper. Nulla facilisi. Integer lacinia sollicitudin massa. Cras metus. Sed aliquet risus a tortor. Integer id quam. Morbi mi. Quisque nisl felis, venenatis tristique, dignissim in, ultrices sit amet, augue. Proin sodales libero eget ante. Nulla quam. Aenean laoreet. 

### Vestibulum Nisi
 
 Lectus, commodo ac, facilisis ac, ultricies eu, pede. Ut orci risus, accumsan porttitor, cursus quis, aliquet eget, justo. Sed pretium blandit orci. Ut eu diam at pede suscipit sodales. Aenean lectus elit, fermentum non, convallis id, sagittis at, neque. Nullam mauris orci, aliquet et, iaculis et, viverra vitae, ligula. Nulla ut felis in purus aliquam imperdiet. Maecenas aliquet mollis lectus. Vivamus consectetuer risus et tortor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. 

### Sed Cursus

Ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. 


#### CLI

You can use the command-line interface to perform the creation and inclusion.

##### Command

```create_and_include.sh```:
```sh
# Option --pristine suppresses comment insertion.
markdown_helper create_page_toc --pristine text.md toc.md
markdown_helper include --pristine includer.md page.md
```

(Option ```--pristine``` suppresses comment insertion.)

#### API

You can use the API to perform the creation and inclusion.

##### Ruby Code

```create_and_include.rb```:
```ruby
require 'markdown_helper'

# Option :printine suppresses the addition of comments.
markdown_helper = MarkdownHelper.new(:pristine => true)
markdown_helper.create_page_toc('text.md', 'toc.md')
markdown_helper.include('includer.md', 'page.md')
```

##### Command

```sh
ruby create_and_include.rb
```

### Finished Page
            
It's big, so linking instead of including:

[page file](page.md)

