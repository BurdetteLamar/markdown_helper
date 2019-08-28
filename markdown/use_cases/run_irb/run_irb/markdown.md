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
