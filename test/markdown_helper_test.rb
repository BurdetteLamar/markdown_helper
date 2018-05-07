require 'diff-lcs'

require 'test_helper'

TEST_DIR_PATH = File.dirname(__FILE__)

class MarkdownHelperTest < Minitest::Test
  
  TEMPLATES_DIR_NAME = 'templates'
  EXPECTED_DIR_NAME = 'expected'
  ACTUAL_DIR_NAME = 'actual'

  def test_version
    refute_nil MarkdownHelper::VERSION
  end

  class TestInfo

    attr_accessor \
      :method_under_test,
      :method_name,
      :md_file_basename,
      :md_file_name,
      :test_dir_path,
      :template_file_path,
      :expected_file_path,
      :actual_file_path,
      :include_file_path

    def initialize(method_under_test)
      self.method_under_test = method_under_test
      self.method_name = method_under_test.to_s
      self.md_file_name = "#{md_file_basename}.md"
      self.test_dir_path = File.join(
          TEST_DIR_PATH,
          method_under_test.to_s
      )
      self.template_file_path = File.join(
          test_dir_path,
          TEMPLATES_DIR_NAME,
          md_file_name
      )
      self.expected_file_path = File.join(
          test_dir_path,
          EXPECTED_DIR_NAME,
          md_file_name
      )
      self.actual_file_path = File.join(
          test_dir_path,
          ACTUAL_DIR_NAME,
          md_file_name
      )
    end

    def templates_dir_path
      File.dirname(template_file_path)
    end

    def expected_dir_path
      File.dirname(expected_file_path)
    end

  end

  class IncludeInfo < TestInfo

    attr_accessor \
      :file_stem,
      :file_type,
      :treatment

    def initialize(file_stem, file_type, treatment)
      self.file_stem = file_stem
      self.file_type = file_type
      self.treatment = treatment
      self.md_file_basename = "#{file_stem}_#{treatment}"
      self.include_file_path = "../includes/#{file_stem}.#{file_type}"
      super(:include)
    end

  end

  class ResolveInfo < TestInfo

    def initialize(md_file_basename)
      self.md_file_basename = md_file_basename
      super(:resolve)
    end
  end

  def test_include

    # Create the template for this test.
    def create_template(test_info)
      File.open(test_info.template_file_path, 'w') do |file|
        if test_info.file_stem == :nothing
          file.puts 'This file includes nothing.'
        else
          # Inspect, in case it's a symbol, and remove double quotes after inspection.
          treatment_for_include = test_info.treatment.inspect.gsub('"','')
          include_line = "@[#{treatment_for_include}](#{test_info.include_file_path})"
          file.puts(include_line)
        end
      end
    end

    # Test combinations of treatments and templates.
    {
        :nothing => :txt,
        :md => :md,
        :python => :py,
        :ruby => :rb,
        :text => :txt,
        :text_no_newline => :txt,
        :xml => :xml,
    }.each_pair do |file_stem, file_type|
      [
          :markdown,
          :code_block,
          :comment,
          file_stem.to_s,
      ].each do |treatment|
        test_info = IncludeInfo.new(
            file_stem,
            file_type,
            treatment,
        )
        create_template(test_info)
        common_test(MarkdownHelper.new, test_info)
      end
    end

    # Test treatment as comment.
    test_info = IncludeInfo.new(
        file_stem = 'comment',
        file_type = 'txt',
        treatment = :comment,
    )
    create_template(test_info)
    common_test(MarkdownHelper.new, test_info)

    # Test nested includes.
    test_info = IncludeInfo.new(
        file_stem = 'nested',
        file_type = 'md',
        treatment = :markdown,
    )
    create_template(test_info)
    common_test(MarkdownHelper.new, test_info)

    # Test circular includes.
    test_info = IncludeInfo.new(
        file_stem = 'circular',
        file_type = 'md',
        treatment = :markdown,
    )
    create_template(test_info)
    assert_raises(RuntimeError) do
      common_test(MarkdownHelper.new, test_info)
    end

    # Test option pristine.
    markdown_helper = MarkdownHelper.new
    [ true, false ].each do |pristine|
      markdown_helper.pristine = pristine
      test_info = IncludeInfo.new(
          file_stem = "pristine_#{pristine}",
          file_type = 'md',
          treatment = :markdown,
      )
      create_template(test_info)
      common_test(markdown_helper, test_info)
    end

  end

  def test_resolve

    # Condition file with repo user and repo name.
    def condition_file(markdown_helper, dir_path, file_name, type)
      file_path = File.join(
          dir_path,
          file_name
      )
      input_text = File.read(file_path)
      repo_user, repo_name = markdown_helper.send(:repo_user_and_name)
      conditioned_text = format(input_text, repo_user, repo_name)
      tmp_dir_name = 'resolve/tmp'
      tmp_dir_path = File.join(
          TEST_DIR_PATH,
          tmp_dir_name,
      )
      Dir.mkdir(tmp_dir_path) unless File.directory?(tmp_dir_path)
      conditioned_file_path = File.join(
          tmp_dir_path,
          "#{type}_#{file_name}",
      )
      conditioned_file = File.new(conditioned_file_path, 'w')
      conditioned_file.write(conditioned_text)
      conditioned_file.close
      conditioned_file
    end

    # Test results of various templates.
    [
        :no_image,
        :simple_image,
        :width_image,
        :width_and_height_image,
    ].each do |md_file_basename|
      markdown_helper = MarkdownHelper.new
      test_info = ResolveInfo.new(md_file_basename)
      template_file = condition_file(markdown_helper, test_info.templates_dir_path, test_info.md_file_name, 'template')
      test_info.template_file_path = template_file.path
      expected_markdown_file = condition_file(markdown_helper, test_info.expected_dir_path, test_info.md_file_name, 'expected')
      test_info.expected_file_path = expected_markdown_file.path
      common_test(markdown_helper, test_info)
    end

    # Test some special cases.
    [
        :not_relative,
        :multiple_images,
        :absolute_and_relative,
    ].each do |md_file_basename|
      test_info = ResolveInfo.new(md_file_basename)
      common_test(MarkdownHelper.new, test_info)
    end

    # Test option pristine.
    md_file_basename = 'pristine'
    test_info = ResolveInfo.new(md_file_basename)
    common_test(
        MarkdownHelper.new(:pristine => true),
        test_info
    )
    markdown_helper = MarkdownHelper.new
    markdown_helper.pristine = true
    common_test(
        markdown_helper,
        test_info
    )

  end

  def common_test(markdown_helper, test_info)
    markdown_helper.send(
        test_info.method_under_test,
        test_info.template_file_path,
        test_info.actual_file_path,
    )
    diffs = MarkdownHelperTest.diff_files(test_info.expected_file_path, test_info.actual_file_path)
    unless diffs.empty?
      puts 'EXPECTED'
      puts File.read(test_info.expected_file_path)
      puts 'ACTUAL'
      puts File.read(test_info.actual_file_path)
      puts 'END'
    end
    assert_empty(diffs, test_info.actual_file_path)
    # CLI
    options = markdown_helper.pristine ? '--pristine' : ''
    File.delete(test_info.actual_file_path)
    command = "markdown_helper #{test_info.method_under_test} #{options} #{test_info.template_file_path} #{test_info.actual_file_path}"
    system(command)
    output = File.read(test_info.actual_file_path)
    diffs = MarkdownHelperTest.diff_files(test_info.expected_file_path, test_info.actual_file_path)
    unless diffs.empty?
      puts 'Expected:'
      puts File.read(test_info.expected_file_path)
      puts 'Got:'
      puts output
    end
    assert_empty(diffs, test_info.actual_file_path)
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
