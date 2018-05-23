### Diagnose Missing Includee

Use the backtrace of inclusions to diagnose and correct a missing or otherwise unreadable includee file.

The backtrace is especially useful for errors in nested includes.

#### Files To Be Included

These files demonstrate nested inclusion, with a missing includee file.

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

@[:code_block](diagnose_missing_includee.err)