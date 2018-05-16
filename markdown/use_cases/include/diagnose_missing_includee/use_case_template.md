### Diagnose Missing Includee

Use the backtrace of inclusions to diagnose and correct a missing or otherwise unreadable includee file.

The backtrace is especially useful for errors in nested includes.

#### Files To Be Included

@[markdown](includer_0.md)

@[markdown](includer_1.md)

@[markdown](includer_2.md)

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

#### Error and Backtrace

@[:code_block](error_and_backtrace.txt)
