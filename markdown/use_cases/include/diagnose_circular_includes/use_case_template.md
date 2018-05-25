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

@[:markdown](../interface.md)

#### Error and Backtrace

Here's the resulting backtrace of inclusions.

@[:code_block](diagnose_circular_includes.err)
