module UseCase

  USE_CASE_FILE_NAME = 'use_case.md'
  TEMPLATE_FILE_NAME = 'use_case_template.md'

  def build_use_case(use_case_dir_path)
    Dir.chdir(use_case_dir_path) do
      yield
      build_command = construct_include_command(TEMPLATE_FILE_NAME, USE_CASE_FILE_NAME, pristine = true)
      system(build_command)
    end
  end

  def write_file(file_name, text)
    File.open(file_name, 'w') do |file|
      file.write(text)
    end
  end

  def construct_include_command(template_file_path, markdown_file_path, pristine = false)
    pristine_option = pristine ? '--pristine ' : ''
    "markdown_helper include #{pristine_option}#{template_file_path} #{markdown_file_path}"
  end

end
