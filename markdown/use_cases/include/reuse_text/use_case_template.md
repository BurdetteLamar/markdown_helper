### Reuse Text

Use file inclusion to stay DRY (Don't Repeat Yourself).

Maintain reusable text in a separate file, then include it wherever it's needed.

#### File To Be Included

@[markdown](includee.md)

#### Includer File

@[markdown](includer.md)

#### CLI

You can use the command-line interface to perform the inclusion.

##### Command

```sh
markdown_helper include --pristine includer.md included.md
```

@[:markdown](../../pristine.md)

#### API

You can use the API to perform the inclusion.

##### Ruby Code

@[ruby](include.rb)

##### Command

```sh
ruby include.rb
```

#### File with Inclusion

Here's the output file, after inclusion.

@[markdown](included.md)
