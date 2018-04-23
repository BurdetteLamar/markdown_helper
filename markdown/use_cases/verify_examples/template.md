### Evergreen Examples

Example code and output that's embedded in a markdown file is dead text that may no longer be correct.

Use the markdown helper to include example code and output -- but only after the project "build" has re-run the code and refreshed the output!

Here's how:

1.  Maintain each code example in a separate executable file.
1.  Maintain markdown files that have include descriptions, rather than embedded code and output.
1.  At project "build time" (controlled by a suitable build tool):
    1.  Execute each code example, capturing its output to one or more files.
    1.  Check output for errors and validity.
    1.  Run the markdown helper to re-assemble the markdown files.