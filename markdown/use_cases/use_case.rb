class UseCase

  # Overall template and output.
  TEMPLATE_FILE_NAME = 'template.md'
  USE_CASE_FILE_NAME = 'use_case.md'
  BUILD_COMMAND = "markdown_helper include --pristine #{TEMPLATE_FILE_NAME} #{USE_CASE_FILE_NAME}"

  # Intermediate files.
  INCLUDER_FILE_NAME = 'includer.md'
  INCLUDED_FILE_NAME = 'included.md'
  INCLUDE_COMMAND = "markdown_helper include --pristine #{INCLUDER_FILE_NAME} #{INCLUDED_FILE_NAME}"

  def write_files(hash)
    hash.each_pair do |file_name, text|
      File.write(file_name, text)
    end
  end

  def build_use_case_markdown(template)
    write_files(TEMPLATE_FILE_NAME => template)
    system(BUILD_COMMAND)
  end

end
