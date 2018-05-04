### Nest Inclusions

An included markdown file can itself include more files.

#### File To Be Included

@[markdown](includee.md)

#### File For Nested Inclusion

@[markdown](nested_includee.md)

#### Includer File

@[markdown](includer.md)

#### Command

```sh
markdown_helper include --pristine includer.md included.md
```

@[:markdown](../../pristine.md)

#### File with Inclusion

Here's the finished file with the inclusion and nested inclusion:

@[markdown](included.md)
