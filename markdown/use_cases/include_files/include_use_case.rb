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

    commands_to_execute.push(RUBY_COMMAND) if File.exist?(RUBY_FILE_NAME)
    commands_to_execute.push(BUILD_COMMAND) if File.exist?(TEMPLATE_FILE_NAME)

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
#### CLI

You can use the command-line interface to perform the inclusion.

##### Command

```sh
#{INCLUDE_COMMAND}
```

@[:markdown](../pristine.md)

#### API

You can use the API to perform the inclusion.

##### Ruby Code

@[ruby](#{RUBY_FILE_NAME})

##### Command

```sh
#{RUBY_COMMAND}
```
EOT
      )
    end

  end

end

