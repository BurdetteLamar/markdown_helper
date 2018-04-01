### Evergreen Examples

Example code and output that's embedded in a markdown file is dead text that may no longer be correct.  Here's how to avoid that:

1.  Maintain each code example in a separate executable file.
1.  Maintain markdown files that have include desctiptions, rather than embedded code and output.
1.  At project "build time" (controlled by a suitable Rake task):
    1.  Execute each code example, capturing, its output to one or more files.
    1.  Check output for errors and validity.
    1.  Run the markdown helper to re-assemble the markdown files.