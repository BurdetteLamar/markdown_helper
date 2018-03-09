require 'test_helper'
require 'tempfile'

require 'diff-lcs'

THIS_DIR_PATH = File.dirname(__FILE__)
TEMPLATES_DIR_PATH = File.join(THIS_DIR_PATH, 'templates')
EXPECTED_DIR_PATH = File.join(THIS_DIR_PATH, 'expected')
ACTUAL_DIR_PATH = File.join(THIS_DIR_PATH, 'actual')

class MarkdownHelperTest < Minitest::Test

  def test_version
    refute_nil MarkdownHelper::VERSION
  end

  def test_include

    # Common to all include tests.
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

    # Create the template for this test.
    def create_template(template_file_path, include_file_path, file_stem, treatment)
      File.open(template_file_path, 'w') do |file|
        if file_stem == :nothing
          file.puts 'This file includes nothing.'
        else
          # Inspect, in case it's a symbol, and remove double quotes after inspection.
          treatment_for_include = treatment.inspect.gsub('"','')
          include_line = "@[#{treatment_for_include}](#{include_file_path})"
          file.puts(include_line)
        end
      end
    end

    {
        :nothing => :txt,
        :markdown => :md,
        :python => :py,
        :ruby => :rb,
        :text => :txt,
        :text_no_newline => :txt,
        :xml => :xml,
    }.each_pair do |file_stem, file_type|
      [
          :verbatim,
          :code_block,
          file_stem.to_s,
      ].each do |treatment|
        file_basename = "#{file_stem}_#{treatment}"
        md_file_name = "#{file_basename}.md"
        template_file_path = File.join(TEMPLATES_DIR_PATH, md_file_name)
        expected_file_path = File.join(EXPECTED_DIR_PATH, md_file_name)
        actual_file_path = File.join(ACTUAL_DIR_PATH, md_file_name)
        include_file_path = "../includes/#{file_stem}.#{file_type}"
        create_template(template_file_path, include_file_path, file_stem, treatment)
        common_test(MarkdownHelper.new, template_file_path, expected_file_path, actual_file_path)
      end
    end

  end

  def test_resolve_image_urls

    # Common to all image tests.
    def common_test(markdown_helper, template_file_path, expected_file_path, actual_file_path)
      output = markdown_helper.resolve_image_urls(
          template_file_path,
          actual_file_path,
      )
      diffs = MarkdownHelperTest.diff_files(expected_file_path, actual_file_path)
      unless diffs.empty?
        puts 'Expected:'
        puts File.read(expected_file_path)
        puts 'Got:'
        puts output
      end
      assert_empty(diffs, actual_file_path)
    end

    [
        :no_image,
        :simple_image,
        :width_image,
        :width_and_height_image,
    ].each do |file_basename|
      markdown_helper = MarkdownHelper.new
      md_file_name = "#{file_basename}.md"
      template_file_path = File.join(TEMPLATES_DIR_PATH, md_file_name)
      repo_user, repo_name = markdown_helper.repo_user_and_name
      # Condition template with repo user and repo name.
      template = File.read(template_file_path)
      conditioned_template = format(template, repo_user, repo_name)
      template_file = Tempfile.new('template.md')
      template_file.write(conditioned_template)
      template_file.close
      # Condition expected markdown with repo user and repo name.
      expected_file_path = File.join(EXPECTED_DIR_PATH, md_file_name)
      expected_markdown = File.read(expected_file_path)
      conditioned_expected_markdown = format(expected_markdown, repo_user, repo_name)
      expected_markdown_file = Tempfile.new('expected_markdown.md')
      expected_markdown_file.write(conditioned_expected_markdown)
      expected_markdown_file.close
      actual_file_path = File.join(ACTUAL_DIR_PATH, md_file_name)
      common_test(markdown_helper, template_file.path, expected_markdown_file.path, actual_file_path)
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
