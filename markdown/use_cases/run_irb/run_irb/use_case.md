### Run Irb

Use the ```run_irb``` feature to execute selected Ruby snippets in the Ruby interactive shell, ```irb```.

This allows you to interleave *any* markdown (usually explanatory text, but actually anything) with the Ruby snippets.

In the example template below, snippets of Ruby are interleaved with other markdown elements.

Each Ruby snippet that's to be executed in ```irb``` is bracketed by pragmas <code>\`\`\`#run_irb</code> and <code>\`\`\`</code>.

In the example, each snippet has some Ruby code that shows values using method ```p```.

<pre>
# About Hashes

Create a hash:

```#run_irb
h = {}
p h.class
p h
```

Initialize a hash:

```#run_irb
h = {:a => 0, :b => 1}
p h
```

Change a value:

```#run_irb
h[:b] = 2
p h
```

Add a new entry:

```#run_irb
h[:c] = 2
p h
```

Delete an entry:

```#run_irb
h.delete(:a)
p h
```</pre>

#### Run Irb Via <code>markdown_helper</code>
<details>
<summary>CLI</summary>

```sh
markdown_helper run_irb --pristine template.md markdown.md
```

(Option ```--pristine``` suppresses comment insertion.)
</details>
<details>
<summary>API</summary>

```run_irb.rb```:
```ruby
require 'markdown_helper'

# Option :pristine suppresses comment insertion.
markdown_helper = MarkdownHelper.new(:pristine => true)
markdown_helper.run_irb('template.md', 'markdown.md')
```

</details>

The resulting markdown (raw) shows the output from ```irb``` for each snippet:

<pre>
# About Hashes

Create a hash:

```ruby
h = {}
p h.class
Hash
p h
{}
```

Initialize a hash:

```ruby
h = {:a => 0, :b => 1}
p h
{:a=>0, :b=>1}
```

Change a value:

```ruby
h[:b] = 2
p h
{:a=>0, :b=>2}
```

Add a new entry:

```ruby
h[:c] = 2
p h
{:a=>0, :b=>2, :c=>2}
```

Delete an entry:

```ruby
h.delete(:a)
p h
{:b=>2, :c=>2}
```
</pre>

Resulting markdown (rendered):

---

# About Hashes

Create a hash:

```ruby
h = {}
p h.class
Hash
p h
{}
```

Initialize a hash:

```ruby
h = {:a => 0, :b => 1}
p h
{:a=>0, :b=>1}
```

Change a value:

```ruby
h[:b] = 2
p h
{:a=>0, :b=>2}
```

Add a new entry:

```ruby
h[:c] = 2
p h
{:a=>0, :b=>2, :c=>2}
```

Delete an entry:

```ruby
h.delete(:a)
p h
{:b=>2, :c=>2}
```

---






