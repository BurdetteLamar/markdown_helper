module UseCase

  def use_case_file_name
    'use_case.md'
  end

  def template_file_name
    'use_case_template.md'
  end

  def file_path(dir_path, file_name)
    File.join(dir_path, file_name)
  end

  def write_file(file_name, text)
    File.open(file_name, 'w') do |file|
      file.write(text)
    end
  end

  def include_command(template_file_path, markdown_file_path, pristine = false)
    pristine_option = pristine ? '--pristine ' : ''
    "markdown_helper include #{pristine_option}#{template_file_path} #{markdown_file_path}"
  end

  def build_use_case
    build_command = include_command(template_file_name, use_case_file_name, pristine = true)
    system(build_command)
  end

end
