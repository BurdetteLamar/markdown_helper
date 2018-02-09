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

  def conventional_test(convention_name, options)
    options = MarkdownHelper::Options.new if options.nil?
    [
        true,
        false,
    ].each do |tag_as_generated|
      options.tag_as_generated = tag_as_generated
      file_name = "#{convention_name}.md"
      suffix = tag_as_generated ? '_tagged' : ''
      suffixed_file_name = "#{convention_name}#{suffix}.md"
      template_file_path = File.join(INPUT_DIR_PATH, file_name)
      markdown_file_path = File.join(ACTUAL_DIR_PATH, suffixed_file_name)
      expected_file_path = File.join(EXPECTED_DIR_PATH, suffixed_file_name)
      output = MarkdownHelper.include(
          template_file_path,
          markdown_file_path,
          options,
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
    {
        :nothing_included => nil,
        :text_included => nil,
        :text_no_newline_included => nil,
        :ruby_included => nil,
        :xml_included => nil,
        :python_included => nil,
    }.each_pair do |convention_name, options|
      conventional_test(convention_name, options)
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
