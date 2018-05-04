<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE use_case_template.md -->
### Include Highlighted Code

Use file inclusion to include text as highlighted code.

#### File to Be Included

Here's a file containing Ruby code to be included:

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
This file includes the code as highlighted code.

@[ruby](hello.rb)

```
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./includer.md -->

The treatment token ```ruby``` specifies that the included text is to be highlighted as Ruby code.

The treatment token can be any Ace mode mentioned in [GitHub Languages](https://github.com/github/linguist/blob/master/lib/linguist/languages.yml).  The file lists about 100 Ace modes, covering just about every language and format.

#### Command

Here's the command to perform the inclusion:

```sh
markdown_helper include includer.md included.md
```

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./../../pristine.md -->
(Option ```--pristine``` suppresses comment insertion.)
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./../../pristine.md -->

#### File with Inclusion

Here's the finished file with the included highlighted code:

<!-- >>>>>> BEGIN INCLUDED FILE (pre): SOURCE ./included.md -->
<pre>
<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE includer.md -->
This file includes the code as highlighted code.

<!-- >>>>>> BEGIN INCLUDED FILE (ruby): SOURCE ./hello.rb -->
```hello.rb```:
```ruby
class HelloWorld
   def initialize(name)
      @name = name.capitalize
   end
   def sayHi
      puts "Hello !"
   end
end
```
<!-- <<<<<< END INCLUDED FILE (ruby): SOURCE ./hello.rb -->

<!-- <<<<<< END GENERATED FILE (include): SOURCE includer.md -->
</pre>
<!-- <<<<<< END INCLUDED FILE (pre): SOURCE ./included.md -->

And here's the finished markdown, as rendered on this page:

---

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE ./included.md -->
<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE includer.md -->
This file includes the code as highlighted code.

<!-- >>>>>> BEGIN INCLUDED FILE (ruby): SOURCE ./hello.rb -->
```hello.rb```:
```ruby
class HelloWorld
   def initialize(name)
      @name = name.capitalize
   end
   def sayHi
      puts "Hello !"
   end
end
```
<!-- <<<<<< END INCLUDED FILE (ruby): SOURCE ./hello.rb -->

<!-- <<<<<< END GENERATED FILE (include): SOURCE includer.md -->
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE ./included.md -->

---
<!-- <<<<<< END GENERATED FILE (include): SOURCE use_case_template.md -->
