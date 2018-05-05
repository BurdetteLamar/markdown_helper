### Include Via API

Use Ruby code to include files via the API.

#### File To Be Included

@[markdown](includee.md)

#### Includer File

@[markdown](includer.md)

#### CLI

##### Command

Here's the command to perform the inclusion:

```sh
markdown_helper include --pristine includer.md included.md
```

@[:markdown](../../pristine.md)

API

##### Ruby File

@[ruby](include.rb)

##### Command

```sh
ruby include.rb
```

@[:markdown](../../pristine.md)

#### File with Inclusion

@[markdown](included.md)
