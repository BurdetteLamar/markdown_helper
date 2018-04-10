reusable_text_file_name = 'reusable_text.md'
includer_file_name = 'includer.md'
included_file_name = 'included.md'

template = <<EOT
### Reusable Text

Use the markdown helper to stay DRY (Don't Repeat Yourself).

Text that will be needed in more than one place in the documentation can be maintained in a separate file, then included wherever it's needed.

Note that the included text may itself be markdown, which can be included verbatim, or it may be code or other example data, which can be included into a code block.

Here's a file containing some text that's to be included in more than one place:

@[:code_block](#{reusable_text_file_name})

Here's a template file that includes it:

@[:code_block](#{includer_file_name})

Here's the command to perform the inclusion:

@[:code_block](command.sh)

And here's the finished file with the file included:

@[:code_block](#{included_file_name})
EOT

reusable_text = <<EOT
This is some useful text that can be included in more than one place (actually, in more than one file).
EOT

includer = <<EOT
This file includes the useful text.

@[:verbatim](#{reusable_text_file_name})
EOT

# Write markdown files.
{
  :template => template,
  :reusable_text => reusable_text,
  :includer => includer,
}.each_pair do |text_name, text|
  file_name = "#{text_name}.md"
  File.write(file_name, text)
end

# Write command files and perform commands.
{
    :command => 'ruby ../../../bin/include --pristine includer.md included.md',
    :build_command => 'ruby ../../../bin/include --pristine template.md use_case.md'
}.each_pair do |name, command|
  file_name = "#{name}.sh"
  File.write(file_name, "#{command}\n")
  system(command)
end
