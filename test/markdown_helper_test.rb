require 'test_helper'

require 'diff-lcs'

THIS_DIR_PATH = File.dirname(__FILE__)
TEMPLATES_DIR_PATH = File.join(THIS_DIR_PATH, 'templates')
EXPECTED_DIR_PATH = File.join(THIS_DIR_PATH, 'expected')
ACTUAL_DIR_PATH = File.join(THIS_DIR_PATH, 'actual')

class MarkdownHelperTest < Minitest::Test

  def test_version
    refute_nil MarkdownHelper::VERSION
  end

  def common_test(markdown_helper, file_stem, handling)
    template_file_name = "#{file_stem}_included.md"
    markdown_file_name = "#{file_stem}_included_#{handling}.md"
    template_file_path = File.join(TEMPLATES_DIR_PATH, template_file_name)
    markdown_file_path = File.join(ACTUAL_DIR_PATH, markdown_file_name)
    expected_file_path = File.join(EXPECTED_DIR_PATH, markdown_file_name)
    output = markdown_helper.include(
        template_file_path,
        markdown_file_path,
    )
    diffs = MarkdownHelperTest.diff_files(expected_file_path, markdown_file_path)
    unless diffs.empty?
      puts"Failed output in #{markdown_file_path}:"
      puts output
    end
    assert_empty(diffs, markdown_file_path)
  end

  def test_handling
    {
        :markdown => :md,
        :python => :py,
        :ruby => :rb,
        :text => :txt,
        :text_no_newline => :txt,
        :xml => :xml,
    }.each_pair do |file_stem, file_type|
      markdown_helper = MarkdownHelper.new
      handling_for_file_type = markdown_helper.get_handling(file_type)
      language = handling_for_file_type.kind_of?(String) ? handling_for_file_type : ''
      [
          :verbatim,
          :code_block,
          language,
      ].each do |handling|
        markdown_helper.set_handling(file_type, handling)
        common_test(markdown_helper, file_stem, handling)
      end
    end
  end
  
  def self.diff_files(expected_file_path, actual_file_path)
    diffs = nil
    File.open(expected_file_path) do |expected_file|
      expected_lines = expected_file.readlines
      File.open(actual_file_path) do |actual_file|
        actual_lines = actual_file.readlines
        diffs = Diff::LCS.diff(expected_lines, actual_lines)
      end
    end
    diffs
  end

end
