### Include with Added Comments

By default (that is, without option ```--pristine```) file inclusion adds comments that:

* Identify the includer file.
* Identify each includee file.

#### Includee File

@[markdown](includee.md)

#### Includer File

@[markdown](includer.md)

#### CLI

You can use the command-line interface to perform the inclusion.

##### Command

```sh
markdown_helper include includer.md included.md
```

#### API

You can use the API to perform the inclusion.

##### Ruby Code

```ruby
require 'markdown_helper'

markdown_helper = MarkdownHelper.new
markdown_helper.include(includer.md, included.md)
```

#### File with Inclusion and Added Comments

@[markdown](included.md)
