# Use Case Code Structure

Each immediate subdirectory here represents a markdown-helper function that is available in both the API and the CLI.

Each diretory therein represents a single se case, and must have:

- A conventionally-named Ruby file that will be executed to build the use case.  The file name is "#{dir_name}.rb".
- A conventionally-named markdown template named ```use_case_template.md```.

The executed Ruby file must create all other files that are required for ths use case.