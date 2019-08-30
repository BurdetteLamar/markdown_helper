### Run Irb

Use the ```run_irb``` feature to execute selected ruby snippets in the Ruby interactive shell, ```irb```.

In the example template below, snippets of Ruby are interleaved with other markdown elements.

Each Ruby snippet that's to be executed in ```irb``` is bracketed by pragmas <code>\`\`\`#run_irb</code> and <code>\`\`\`</code>.

In the example, each snippet has some Ruby code that shows values using method ```p```.

@[:pre](template.md)

@[:markdown](../interface.md)

The resulting markdown (raw) shows the output from ```irb``` for each snippet:

@[:pre](markdown.md)

Resulting markdown (rendered):

@[:markdown](markdown.md)





