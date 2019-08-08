require_relative '../use_case'

class IncludeUseCase < UseCase

  attr_accessor :use_case_dir_name

  INCLUDE_DIR_PATH = File.dirname(__FILE__)

  INCLUDEE_FILE_NAME = 'includee.md'
  INCLUDER_FILE_NAME = 'includer.md'
  INCLUDED_FILE_NAME = 'included.md'

  RUBY_FILE_NAME = 'include.rb'
  RUBY_COMMAND = "ruby #{RUBY_FILE_NAME}"

  INCLUDE_COMMAND = IncludeUseCase.construct_include_command(INCLUDER_FILE_NAME, INCLUDED_FILE_NAME, pristine = true)

  BUILD_COMMAND = UseCase.construct_include_command(TEMPLATE_FILE_NAME, USE_CASE_FILE_NAME, pristine = true)

  def initialize
    super
    commands_to_execute.push(BUILD_COMMAND)
    self.use_case_dir_name = use_case_dir_name
  end

  def use_case_dir_path
    File.join(File.absolute_path(File.dirname(__FILE__)), use_case_dir_name)
  end

  def write_includee_file
    File.write(
        INCLUDEE_FILE_NAME,
        <<EOT
Text in includee file.
EOT
    )
  end

  def write_includer_file
    File.write(
        INCLUDER_FILE_NAME,
        <<EOT
Text in includer file.

@[:markdown](#{INCLUDEE_FILE_NAME})

EOT
    )
  end

  def write_ruby_file(pristine)
    args = pristine ? '(:pristine => true)' : ''
    File.write(
        RUBY_FILE_NAME,
        <<EOT
require 'markdown_helper'

# Option :pristine suppresses comment insertion.
markdown_helper = MarkdownHelper.new#{args}
markdown_helper.include('#{INCLUDER_FILE_NAME}', '#{INCLUDED_FILE_NAME}')
EOT
    )
  end

  def self.write_interface_file
    interface_file_path = File.join(
        INCLUDE_DIR_PATH,
        'interface.md',
    )
    File.open(interface_file_path, 'w') do |interface_file|
      interface_file.puts(<<EOT
#### Include Via <code>markdown_helper</code>
<details>
<summary>CLI</summary>
```sh
#{INCLUDE_COMMAND}
```
@[:markdown](../pristine.md)
</details>
<details>
<summary>API</summary>
##### Ruby Code
@[ruby](../#{RUBY_FILE_NAME})
```
</details>
EOT
      )
    end

  end

end

