require 'test_helper'
require 'tempfile'

require 'diff-lcs'

TEST_DIR_PATH = File.dirname(__FILE__)

class MarkdownHelperTest < Minitest::Test
  
  TEMPLATES_DIR_NAME = 'templates'
  EXPECTED_DIR_NAME = 'expected'
  ACTUAL_DIR_NAME = 'actual'

  def test_version
    refute_nil MarkdownHelper::VERSION
  end

  def test_include

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

    method_under_test = :include

    test_dir_path = File.join(
        TEST_DIR_PATH,
        method_under_test.to_s,
    )
    templates_dir_path = File.join(
        test_dir_path,
        TEMPLATES_DIR_NAME,
    )
    expected_dir_path = File.join(
        test_dir_path,
        EXPECTED_DIR_NAME,
    )
    actual_dir_path = File.join(
        test_dir_path,
        ACTUAL_DIR_NAME,
    )

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
        template_file_path = File.join(
            templates_dir_path,
            md_file_name
        )
        expected_file_path = File.join(
            expected_dir_path,
            md_file_name
        )
        actual_file_path = File.join(
            actual_dir_path,
            md_file_name
        )
        include_file_path = "../includes/#{file_stem}.#{file_type}"
        create_template(template_file_path, include_file_path, file_stem, treatment)
        common_test(MarkdownHelper.new, method_under_test, template_file_path, expected_file_path, actual_file_path)
      end
    end

  end

  def test_resolve_image_urls

    method_under_test = :resolve_image_urls

    # Test results of various templates.
    [
        :no_image,
        :simple_image,
        :width_image,
        :width_and_height_image,
    ].each do |file_basename|
      markdown_helper = MarkdownHelper.new
      md_file_name = "#{file_basename}.md"
      repo_user, repo_name = markdown_helper.repo_user_and_name
      # Condition template with repo user and repo name.
      template_file_path = File.join(
          TEST_DIR_PATH,
          'resolve_image_urls',
          TEMPLATES_DIR_NAME,
          md_file_name
      )
      template = File.read(template_file_path)
      conditioned_template = format(template, repo_user, repo_name)
      template_file = Tempfile.new('template.md')
      template_file.write(conditioned_template)
      template_file.close
      # Condition expected markdown with repo user and repo name.
      expected_file_path = File.join(
          TEST_DIR_PATH,
          'resolve_image_urls',
          EXPECTED_DIR_NAME,
          md_file_name
      )
      expected_markdown = File.read(expected_file_path)
      conditioned_expected_markdown = format(expected_markdown, repo_user, repo_name)
      expected_markdown_file = Tempfile.new('expected_markdown.md')
      expected_markdown_file.write(conditioned_expected_markdown)
      expected_markdown_file.close
      actual_file_path = File.join(
          TEST_DIR_PATH,
          'resolve_image_urls',
          ACTUAL_DIR_NAME,
          md_file_name
      )
      common_test(markdown_helper, method_under_test, template_file.path, expected_markdown_file.path, actual_file_path)
    end

    # Test some special cases.
    [
        # Image path is already an absolute URL.
        :not_relative,
        # Line with image has following text.
        :text_following,
    ].each do |basename|
      md_file_name = "#{basename}.md"
      markdown_helper = MarkdownHelper.new
      template_file_path = File.join(
          TEST_DIR_PATH,
          'resolve_image_urls',
          TEMPLATES_DIR_NAME,
          md_file_name
      )
      expected_file_path = File.join(
          TEST_DIR_PATH,
          'resolve_image_urls',
          EXPECTED_DIR_NAME,
          md_file_name
      )
      actual_file_path = File.join(
          TEST_DIR_PATH,
          'resolve_image_urls',
          ACTUAL_DIR_NAME,
          md_file_name
      )
      common_test(markdown_helper, method_under_test, template_file_path, expected_file_path, actual_file_path)
    end

  end

  def common_test(markdown_helper, method_under_test, template_file_path, expected_file_path, actual_file_path)
    # API
    output = markdown_helper.send(
        method_under_test,
        template_file_path,
        actual_file_path,
    )
    diffs = MarkdownHelperTest.diff_files(expected_file_path, actual_file_path)
    unless diffs.empty?
      puts"Failed output in #{actual_file_path}:"
      puts output
    end
    assert_empty(diffs, actual_file_path)
    # CLI
    bin_file = File.join(
        TEST_DIR_PATH,
        '..',
        'bin',
        method_under_test.to_s,
    )
    command = format("ruby #{bin_file} #{template_file_path} #{actual_file_path}")
    system(command)
    output = File.read(actual_file_path)
    diffs = MarkdownHelperTest.diff_files(expected_file_path, actual_file_path)
    unless diffs.empty?
      puts 'Expected:'
      puts File.read(expected_file_path)
      puts 'Got:'
      puts output
    end
    assert_empty(diffs, actual_file_path)
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
