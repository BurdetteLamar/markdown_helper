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

@[:markdown](../interface.md)

#### Error and Backtrace

Here's the resulting backtrace of inclusions.

@[:code_block](diagnose_missing_includee.err)
