<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE use_case_template.md -->
### Include a Code Block

Use file inclusion to include text as a code block.

#### File to Be Included

Here's a file containing code to be included:

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./hello.rb -->
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
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./hello.rb -->

#### Includer File

Here's a template file that includes it:

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./includer.md -->
```includer.md```:
```markdown
This file includes the code as a code block.

@[:code_block](hello.rb)

```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./includer.md -->

The treatment token ```:code_block``` specifies that the included text is to be treated as a code block.

#### Command

Here's the command to perform the inclusion:

```sh
markdown_helper include includer.md included.md
```

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./../../pristine.md -->
(Option ```--pristine``` suppresses comment insertion.)
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./../../pristine.md -->

#### File with Inclusion

Here's the finished file with the included code block:

<!-- >>>>>> BEGIN INCLUDED FILE (pre): SOURCE ./included.md -->
<pre>
<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE includer.md -->
This file includes the code as a code block.

<!-- >>>>>> BEGIN INCLUDED FILE (code_block): SOURCE ./hello.rb -->
```hello.rb```:
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
<!-- <<<<<< END INCLUDED FILE (code_block): SOURCE ./hello.rb -->

<!-- <<<<<< END GENERATED FILE (include): SOURCE includer.md -->
</pre>
<!-- <<<<<< END INCLUDED FILE (pre): SOURCE ./included.md -->

And here's the finished markdown, as rendered on this page:

---

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./included.md -->
<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE includer.md -->
This file includes the code as a code block.

<!-- >>>>>> BEGIN INCLUDED FILE (code_block): SOURCE ./hello.rb -->
```hello.rb```:
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
<!-- <<<<<< END INCLUDED FILE (code_block): SOURCE ./hello.rb -->

<!-- <<<<<< END GENERATED FILE (include): SOURCE includer.md -->
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./included.md -->

---
<!-- <<<<<< END GENERATED FILE (include): SOURCE use_case_template.md -->
