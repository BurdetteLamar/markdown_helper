### Diagnose Circular Includes

Use the backtrace of inclusions to diagnose and correct circular inclusions:  that is inclusions that directly or indirectly cause a file to include itself.

#### Files To Be Included

These files demonstrate nested inclusion, with circular inclusions.

@[markdown](includer_0.md)

@[markdown](includer_1.md)

@[markdown](includer_2.md)

#### Includer File

This file initiates the nested inclusions.

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

#### Error and Backtrace

Here's the resulting backtrace of inclusions.

@[:code_block](diagnose_circular_includes.err)
