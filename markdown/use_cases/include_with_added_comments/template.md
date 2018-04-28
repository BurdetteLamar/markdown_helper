### Include with Added Comments

By default (that is, without option ```--pristine```) file inclusion adds comments that:

* Identify the includer file.
* Identify each includee file.

#### Includee File

@[markdown](includee.md)

#### Includer File

@[markdown](includer.md)

#### Inclusion Command

```sh
markdown_helper include includer.md included.md
```

#### File with Inclusion and Added Comments

@[markdown](included.md)
