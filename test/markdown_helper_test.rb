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

  def conventional_test(convention_name, features)
    file_name = "#{convention_name}.md"
    template_file_path = File.join(INPUT_DIR_PATH, file_name)
    markdown_file_path = File.join(ACTUAL_DIR_PATH, file_name)
    expected_file_path = File.join(EXPECTED_DIR_PATH, file_name)
    args = [
        template_file_path,
        markdown_file_path,
    ]
    args.push(features) if features
    MarkdownHelper.include(*args)
    diffs = MarkdownHelperTest.diff_files(expected_file_path, markdown_file_path)
    assert_empty(diffs)
  end

  def test_conventionally
    {
        :nothing_included => nil,
        :text_included => nil,
        :tagged_as_generated => MarkdownHelper::Features.new(tag_as_generated: true)
    }.each_pair do |convention_name, features|
      conventional_test(convention_name, features)
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
