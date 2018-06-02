### Reuse Text

Use file inclusion to stay DRY (Don't Repeat Yourself).

Maintain reusable text in a separate file, then include it wherever it's needed.

#### File To Be Included

@[markdown](includee.md)

#### Includer File

@[markdown](includer.md)

The treatment token ```:markdown``` specifies that the included text is to be treated as more markdown.

@[:markdown](../interface.md)

#### File with Inclusion

Here's the output file, after inclusion.

@[markdown](included.md)
