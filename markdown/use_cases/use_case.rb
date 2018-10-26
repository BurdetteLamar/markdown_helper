class UseCase

  attr_accessor :use_case_dir_path, :files_to_write, :commands_to_execute

  USE_CASE_FILE_NAME = 'use_case.md'
  TEMPLATE_FILE_NAME = 'use_case_template.md'

  def initialize(use_case_dir_path)
    self.use_case_dir_path = use_case_dir_path
    self.files_to_write = {}
    self.commands_to_execute = []
  end

  def build
    Dir.chdir(use_case_dir_path) do
      files_to_write.each_pair do |file_name, text|
        File.open(file_name, 'w') do |file|
          file.write(text)
        end
      end
      commands_to_execute.each do |command|
        system(command)
      end
    end
  end

  def construct_command(command, template_file_path, markdown_file_path, pristine = false)
    pristine_option = pristine ? '--pristine ' : ''
    "markdown_helper #{command} #{pristine_option}#{template_file_path} #{markdown_file_path}"
  end

  def construct_include_command(template_file_path, markdown_file_path, pristine = false)
    construct_command(:include, template_file_path, markdown_file_path, pristine)
  end

  def UseCase.construct_include_command(template_file_path, markdown_file_path, pristine = false)
    pristine_option = pristine ? '--pristine ' : ''
    "markdown_helper include #{pristine_option}#{template_file_path} #{markdown_file_path}"
  end

end
