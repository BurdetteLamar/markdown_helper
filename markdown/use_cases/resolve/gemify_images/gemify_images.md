### Gemify Images

Use the markdown helper to resolve image paths for a Ruby gem.

When you release your GitHub project to  gem at RubyGems.org, the documentation is rebuilt into files on RubyDoc.info.  When YARD performs this rebuilding, it does some directory restructuring.

If a markdown file contains an image description that has a relative file path, that path will not be valid in the documentation on RubyDoc.info, and the image will not display in the documentation.

To avoid that error, use the markdown helper to resolve the relative path to an absolute path.

This new absolute path points to a file that's automatically maintained in the GitHub project.  For that reason,
