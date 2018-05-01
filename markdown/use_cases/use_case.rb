module UseCase

  def use_case_file_path(dir_path)
    File.join(dir_path, 'use_case.md')
  end

  def template_file_name
    'use_case_template.md'
  end

  def template_file_path(dir_path)
    File.join(dir_path, 'use_case_template.md')
  end
  
  def file_path(dir_path, file_name)
    File.join(dir_path, file_name)
  end

  def write_file(dir_path, file_name, text)
    file_path = File.join(dir_path, file_name)
    File.open(file_path, 'w') do |file|
      file.write(text)
    end
  end

  def include_command(template_file_path, markdown_file_path, pristine = false)
    pristine_option = pristine ? '--pristine ' : ''
    "markdown_helper include #{pristine_option}#{template_file_path} #{markdown_file_path}"
  end

  def do_example_inclusion(use_case_dir_path, include_command)
    Dir.chdir(use_case_dir_path) do
      system(include_command)
    end
  end

  def build_use_case(template_file_path, markdown_file_path)
    build_command = include_command(template_file_path, markdown_file_path, pristine = true)
    system(build_command)
  end

end
