### Include Text As Comment

Use file inclusion to include text (or even code) as a comment.

#### File to Be Included

Here's a file containing code to be included:

```hello.rb```:
```markdown
class HelloWorld
   def initialize(name)
      @name = name.capitalize
   end
   def sayHi
      puts "Hello !"
   end
end
```

#### Includer File

Here's a template file that includes it:

```includer.md```:
```markdown
This file includes the code as a comment.

@[:comment](hello.rb)
```

The treatment token ```:comment``` specifies that the included text is to be treated as a comment.

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

Here's the finished file with the included comment:

```included.md```:
```markdown
This file includes the code as a comment.

<!--class HelloWorld
   def initialize(name)
      @name = name.capitalize
   end
   def sayHi
      puts "Hello !"
   end
end
-->
```

