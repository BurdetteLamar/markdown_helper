### Include Text As Comment

Use file inclusion to include text (or even code) as a comment.

#### File to Be Included

Here's a file containing code to be included:

@[markdown](hello.rb)

#### Includer File

Here's a template file that includes it:

@[markdown](includer.md)

The treatment token ```:comment``` specifies that the included text is to be treated as a comment.

@[:markdown](../interface.md)

#### File with Inclusion

Here's the finished file with the included comment:

@[markdown](included.md)

