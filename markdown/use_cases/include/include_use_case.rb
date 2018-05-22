require_relative '../use_case'

class IncludeUseCase < UseCase

  attr_accessor :use_case_dir_name

  INCLUDEE_FILE_NAME = 'includee.md'
  INCLUDER_FILE_NAME = 'includer.md'
  INCLUDED_FILE_NAME = 'included.md'
  RUBY_FILE_NAME = 'include.rb'
  RUBY_COMMAND = "ruby #{RUBY_FILE_NAME}"
  INCLUDE_COMMAND = IncludeUseCase.construct_include_command(INCLUDER_FILE_NAME, INCLUDED_FILE_NAME, pristine = true)
  BUILD_COMMAND = IncludeUseCase.construct_include_command(TEMPLATE_FILE_NAME, USE_CASE_FILE_NAME, pristine = true)

  def initialize(use_case_dir_name)

    super

    self.use_case_dir_name = use_case_dir_name

    commands_to_execute.push(
        RUBY_COMMAND,
        BUILD_COMMAND,
    )

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

end

