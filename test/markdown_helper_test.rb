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

  def common_test(markdown_helper, template_file_path, expected_file_path, actual_file_path)
    output = markdown_helper.include(
        template_file_path,
        actual_file_path,
    )
    diffs = MarkdownHelperTest.diff_files(expected_file_path, actual_file_path)
    unless diffs.empty?
      puts"Failed output in #{actual_file_path}:"
      puts output
    end
    assert_empty(diffs, actual_file_path)
  end

  def test_treatment
    {
        :nothing => :txt,
        :markdown => :md,
        :python => :py,
        :ruby => :rb,
        :text => :txt,
        :text_no_newline => :txt,
        :xml => :xml,
    }.each_pair do |file_stem, file_type|
      markdown_helper = MarkdownHelper.new
      treatment_for_file_type = markdown_helper.get_treatment(file_type)
      language = treatment_for_file_type.kind_of?(String) ? treatment_for_file_type : ''
      [
          :verbatim,
          :code_block,
          file_stem,
      ].each do |treatment|
        file_basename = "#{file_stem}_#{treatment}"
        md_file_name = "#{file_basename}.md"
        template_file_path = File.join(TEMPLATES_DIR_PATH, md_file_name)
        expected_file_path = File.join(EXPECTED_DIR_PATH, md_file_name)
        actual_file_path = File.join(ACTUAL_DIR_PATH, md_file_name)
        include_file_path = "../includes/#{file_stem}.#{file_type}"
        create_template(template_file_path, include_file_path, file_stem, treatment)
        common_test(markdown_helper, template_file_path, expected_file_path, actual_file_path)
      end
    end
  end

  # def test_tag_as_generated
  #   [
  #       :verbatim,
  #       :code_block,
  #       'xml',
  #   ].each do |treatment|
  #     markdown_helper = MarkdownHelper.new
  #     markdown_helper.set_treatment(:xml, treatment)
  #     markdown_helper.tag_as_generated = true
  #     common_test(markdown_helper, :xml, treatment)
  #   end
  # end

  def create_template(template_file_path, include_file_path, file_stem, treatment)
    File.open(template_file_path, 'w') do |file|
      if file_stem == :nothing
        file.puts 'This file includes nothing.'
      else
        include_line = "@[#{treatment}](#{include_file_path})"
        file.puts(include_line)
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
