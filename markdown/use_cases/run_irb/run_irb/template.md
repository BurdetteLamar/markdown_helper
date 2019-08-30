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
```