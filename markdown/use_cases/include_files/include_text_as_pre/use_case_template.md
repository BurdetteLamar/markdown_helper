### Include Text As Pre

Use file inclusion to include text as pre-formatted (rather than as a code block).

You might need to do this if you have text to include that has triple-backticks.

#### File to Be Included

Here's a file containing text to be included; the text has triple-backticks.:

@[markdown](triple_backtick.md)

#### Includer File

Here's a template file that includes it:

@[markdown](includer.md)

The treatment token ```:pre``` specifies that the included text is to be treated as pre-formatted.

@[:markdown](../interface.md)

#### File with Inclusion

Here's the finished file with the included preformatted text:

@[markdown](included.md)

