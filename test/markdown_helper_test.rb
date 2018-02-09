require 'test_helper'

require 'diff-lcs'

THIS_DIR_PATH = File.dirname(__FILE__)
INPUT_DIR_PATH = File.join(THIS_DIR_PATH, 'input')
EXPECTED_DIR_PATH = File.join(THIS_DIR_PATH, 'expected')
ACTUAL_DIR_PATH = File.join(THIS_DIR_PATH, 'actual')

class MarkdownHelperTest < Minitest::Test

  def test_version
    refute_nil ::MarkdownHelper::VERSION
  end

  def test_nothing_included
    template_file_path = File.join(INPUT_DIR_PATH, 'nothing_included.md')
    markdown_file_path = File.join(ACTUAL_DIR_PATH, 'nothing_included.md')
    expected_file_path = File.join(EXPECTED_DIR_PATH, 'nothing_included.md')
    MarkdownHelper.include(template_file_path, markdown_file_path)
    diffs = MarkdownHelperTest.diff_files(expected_file_path, markdown_file_path)
    assert_empty(diffs)
  end

  def test_text_included
    template_file_path = File.join(INPUT_DIR_PATH, 'text_included.md')
    markdown_file_path = File.join(ACTUAL_DIR_PATH, 'text_included.md')
    expected_file_path = File.join(EXPECTED_DIR_PATH, 'text_included.md')
    MarkdownHelper.include(template_file_path, markdown_file_path)
    diffs = MarkdownHelperTest.diff_files(expected_file_path, markdown_file_path)
    assert_empty(diffs)
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
