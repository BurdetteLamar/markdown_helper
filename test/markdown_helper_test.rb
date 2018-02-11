require 'test_helper'

require 'diff-lcs'

THIS_DIR_PATH = File.dirname(__FILE__)
INPUT_DIR_PATH = File.join(THIS_DIR_PATH, 'input')
EXPECTED_DIR_PATH = File.join(THIS_DIR_PATH, 'expected')
ACTUAL_DIR_PATH = File.join(THIS_DIR_PATH, 'actual')

class MarkdownHelperTest < Minitest::Test

  def test_version
    refute_nil MarkdownHelper::VERSION
  end

  def common_test(file_stem, markdown_helper = MarkdownHelper.new)
    [
        true,
        false,
    ].each do |tag_as_generated|
      markdown_helper.tag_as_generated = tag_as_generated
      file_name = "#{file_stem}.md"
      suffix = tag_as_generated ? '_tagged' : ''
      suffixed_file_name = "#{file_stem}#{suffix}.md"
      template_file_path = File.join(INPUT_DIR_PATH, file_name)
      markdown_file_path = File.join(ACTUAL_DIR_PATH, suffixed_file_name)
      expected_file_path = File.join(EXPECTED_DIR_PATH, suffixed_file_name)
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

  end

  def test_conventionally
    %w/
        nothing_included
        text_included
        text_no_newline_included
        ruby_included
        xml_included
        markdown_included
    /.each do |file_stem|
      common_test(file_stem)
    end
  end
  
  def test_python
    markdown_helper = MarkdownHelper.new
    markdown_helper.highlight_file_type(:py, 'python')
    common_test('python_included', markdown_helper)
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
