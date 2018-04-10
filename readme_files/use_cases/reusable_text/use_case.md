### Reusable Text

Use the markdown helper to stay DRY (Don't Repeat Yourself).

Text that will be needed in more than one place in the documentation can be maintained in a separate file, then included wherever it's needed.

Note that the included text may itself be markdown, which can be included verbatim, or it may be code or other example data, which can be included into a code block.

Here's a file containing some text that's to be included in more than one place:

<code>reusable_text.md</code>
```
This is some useful text that can be included in more than one place (actually, in more than one file).
```

Here's a template file that includes it:

<code>includer.md</code>
```
This file includes the useful text.

@[:verbatim](reusable_text.md)
```

Here's the command to perform the inclusion:

<code>command.sh</code>
```
ruby ../../../bin/include --pristine includer.md included.md
```

And here's the finished file with the file included:

<code>included.md</code>
```
This file includes the useful text.

This is some useful text that can be included in more than one place (actually, in more than one file).
```
