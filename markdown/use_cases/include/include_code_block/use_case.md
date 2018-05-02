### Include a Code Block

Use file inclusion to include text as a code block.

#### File to Be Included

Here's a file containing code to be included:

<code>hello.rb</code>
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

<code>includer.md</code>
```markdown
This file includes the code as a code block.

@[:code_block](hello.rb)

```

The treatment token ```:code_block``` specifies that the included text is to be treated as a code block.

#### Command

Here's the command to perform the inclusion:

```sh
markdown_helper include --pristine includer.md included.md
```

(Option ```--pristine``` suppresses comment insertion.)

#### File with Inclusion

Here's the finished file with the included code block:

<pre>
This file includes the code as a code block.

<code>hello.rb</code>
```
class HelloWorld
   def initialize(name)
      @name = name.capitalize
   end
   def sayHi
      puts "Hello !"
   end
end
```

</pre>

And here's the finished markdown, as rendered on this page:

---

class HelloWorld
   def initialize(name)
      @name = name.capitalize
   end
   def sayHi
      puts "Hello !"
   end
end

---
