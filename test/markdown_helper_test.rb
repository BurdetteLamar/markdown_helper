require 'diff-lcs'

require 'test_helper'

TEST_DIR_PATH = File.dirname(__FILE__)

class MarkdownHelperTest < Minitest::Test
  
  TEMPLATES_DIR_NAME = 'templates'
  EXPECTED_DIR_NAME = 'expected'
  ACTUAL_DIR_NAME = 'actual'

  class TestInfo

    attr_accessor \
      :method_under_test,
      :method_name,
      :file_stem,
      :file_type,
      :treatment

    def initialize(method_under_test, file_stem, file_type, treatment)
      self.method_under_test = method_under_test
      self.method_name = method_under_test.to_s
      self.file_stem = file_stem
      self.file_type = file_type
      self.treatment = treatment
    end

    def file_basename
      "#{file_stem}_#{treatment}"
    end

    def md_file_name
      "#{file_basename}.md"
    end

    def  templates_dir_path
      File.join(
          test_dir_path,
          TEMPLATES_DIR_NAME,
      )
    end

    def test_dir_path
      File.join(
          TEST_DIR_PATH,
          method_under_test.to_s,
      )
    end

    def expected_dir_path
      File.join(
          test_dir_path,
          EXPECTED_DIR_NAME,
      )
    end

    def actual_dir_path
      File.join(
          test_dir_path,
          ACTUAL_DIR_NAME,
      )
    end

    def template_file_path
      File.join(
          templates_dir_path,
          md_file_name
      )
    end

    def expected_file_path
      File.join(
        expected_dir_path,
        md_file_name
    )
    end

    def actual_file_path
      File.join(
        actual_dir_path,
        md_file_name,
    )
    end

    def include_file_path
      "../includes/#{file_stem}.#{file_type}"
    end

  end


  def test_version
    refute_nil MarkdownHelper::VERSION
  end

  def test_include

    method = :include

    # Create the template for this test.
    def create_template(test_info)
      # p 'CREATE_TEMPLATE'
      # p test_info.template_file_path
      File.open(test_info.template_file_path, 'w') do |file|
        if test_info.file_stem == :nothing
          file.puts 'This file includes nothing.'
        else
          # Inspect, in case it's a symbol, and remove double quotes after inspection.
          treatment_for_include = test_info.treatment.inspect.gsub('"','')
          include_line = "@[#{treatment_for_include}](#{test_info.include_file_path})"
          file.puts(include_line)
          # p include_line
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
        test_info = TestInfo.new(
            method,
            file_stem,
            file_type,
            treatment,
        )
        create_template(test_info)
        common_test(MarkdownHelper.new, test_info)
      end
    end

    # Test treatment as comment.
    # test_info = TestInfo.new(
    #     method,
    #     file_stem = nil,
    #     file_type = 'txt',
    #     treatment = :comment,
    # )
    # create_template(test_info)
    # common_test(MarkdownHelper.new, test_info)
    # md_file_name = 'comment.md'
    # template_file_path = File.join(
    #     templates_dir_path,
    #     md_file_name
    # )
    # expected_file_path = File.join(
    #     expected_dir_path,
    #     md_file_name
    # )
    # actual_file_path = File.join(
    #     actual_dir_path,
    #     md_file_name
    # )
    # include_file_path = '../includes/comment.txt'
    # create_template(template_file_path, include_file_path, 'comment', :comment)
    # common_test(
    #     MarkdownHelper.new,
    #     method_under_test,
    #     template_file_path,
    #     expected_file_path,
    #     actual_file_path
    # )
    #
    # # Test nested includes.
    # md_file_name = 'nested.md'
    # template_file_path = File.join(
    #     templates_dir_path,
    #     md_file_name
    # )
    # expected_file_path = File.join(
    #     expected_dir_path,
    #     md_file_name
    # )
    # actual_file_path = File.join(
    #     actual_dir_path,
    #     md_file_name
    # )
    # common_test(
    #     MarkdownHelper.new,
    #     method_under_test,
    #     template_file_path,
    #     expected_file_path,
    #     actual_file_path
    # )
    #
    # # Test circular include.
    # md_file_name = 'circular.md'
    # template_file_path = File.join(
    #     templates_dir_path,
    #     md_file_name
    # )
    # expected_file_path = File.join(
    #     expected_dir_path,
    #     md_file_name
    # )
    # actual_file_path = File.join(
    #     actual_dir_path,
    #     md_file_name
    # )
    # assert_raises(RuntimeError) do
    #   common_test(
    #       MarkdownHelper.new,
    #       method_under_test,
    #       template_file_path,
    #       expected_file_path,
    #       actual_file_path
    #   )
    # end
    #
    # # Test option pristine.
    # md_file_name = 'pristine.md'
    # template_file_path = File.join(
    #     templates_dir_path,
    #     md_file_name
    # )
    # expected_file_path = File.join(
    #     expected_dir_path,
    #     md_file_name
    # )
    # actual_file_path = File.join(
    #     actual_dir_path,
    #     md_file_name
    # )
    # include_file_path = '../includes/ruby.rb'
    # create_template(template_file_path, include_file_path, 'pristine', :code_block)
    # common_test(
    #     MarkdownHelper.new(:pristine => true),
    #     method_under_test,
    #     template_file_path,
    #     expected_file_path,
    #     actual_file_path
    # )
    # markdown_helper = MarkdownHelper.new
    # markdown_helper.pristine = true
    # common_test(
    #     markdown_helper,
    #     method_under_test,
    #     template_file_path,
    #     expected_file_path,
    #     actual_file_path
    # )

  end

  def test_resolve

  #   method_under_test = :resolve
  #
  #   test_dir_path = File.join(
  #       TEST_DIR_PATH,
  #       method_under_test.to_s,
  #   )
  #   templates_dir_path = File.join(
  #       test_dir_path,
  #       TEMPLATES_DIR_NAME,
  #   )
  #   expected_dir_path = File.join(
  #       test_dir_path,
  #       EXPECTED_DIR_NAME,
  #   )
  #   actual_dir_path = File.join(
  #       test_dir_path,
  #       ACTUAL_DIR_NAME,
  #   )
  #
  #   # Condition file with repo user and repo name.
  #   def condition_file(markdown_helper, dir_path, file_name, type)
  #     file_path = File.join(
  #         dir_path,
  #         file_name
  #     )
  #     input_text = File.read(file_path)
  #     repo_user, repo_name = markdown_helper.send(:repo_user_and_name)
  #     conditioned_text = format(input_text, repo_user, repo_name)
  #     tmp_dir_name = 'resolve/tmp'
  #     tmp_dir_path = File.join(
  #         TEST_DIR_PATH,
  #         tmp_dir_name,
  #     )
  #     Dir.mkdir(tmp_dir_path) unless File.directory?(tmp_dir_path)
  #     conditioned_file_path = File.join(
  #         tmp_dir_path,
  #         "#{type}_#{file_name}",
  #     )
  #     conditioned_file = File.new(conditioned_file_path, 'w')
  #     conditioned_file.write(conditioned_text)
  #     conditioned_file.close
  #     conditioned_file
  #   end
  #
  #   # Test results of various templates.
  #   [
  #       :no_image,
  #       :simple_image,
  #       :width_image,
  #       :width_and_height_image,
  #   ].each do |file_basename|
  #     markdown_helper = MarkdownHelper.new
  #     md_file_name = "#{file_basename}.md"
  #     template_file = condition_file(markdown_helper, templates_dir_path, md_file_name, 'template')
  #     expected_markdown_file = condition_file(markdown_helper, expected_dir_path, md_file_name, 'expected')
  #     actual_file_path = File.join(
  #         actual_dir_path,
  #         md_file_name
  #     )
  #     common_test(
  #         markdown_helper,
  #         method_under_test,
  #         template_file.path,
  #         expected_markdown_file.path,
  #         actual_file_path
  #     )
  #   end
  #
  #   # Test some special cases.
  #   [
  #       :not_relative,
  #       :multiple_images,
  #       :absolute_and_relative,
  #   ].each do |basename|
  #     md_file_name = "#{basename}.md"
  #     markdown_helper = MarkdownHelper.new
  #     template_file_path = File.join(
  #         templates_dir_path,
  #         md_file_name
  #     )
  #     expected_file_path = File.join(
  #         expected_dir_path,
  #         md_file_name
  #     )
  #     actual_file_path = File.join(
  #         actual_dir_path,
  #         md_file_name
  #     )
  #     common_test(markdown_helper, method_under_test, template_file_path, expected_file_path, actual_file_path)
  #   end
  #
  #   # Test option pristine.
  #   md_file_name = 'pristine.md'
  #   template_file_path = File.join(
  #       templates_dir_path,
  #       md_file_name
  #   )
  #   expected_file_path = File.join(
  #       expected_dir_path,
  #       md_file_name
  #   )
  #   actual_file_path = File.join(
  #       actual_dir_path,
  #       md_file_name
  #   )
  #   common_test(
  #       MarkdownHelper.new(:pristine => true),
  #       method_under_test,
  #       template_file_path,
  #       expected_file_path,
  #       actual_file_path
  #   )
  #   markdown_helper = MarkdownHelper.new
  #   markdown_helper.pristine = true
  #   common_test(
  #       markdown_helper,
  #       method_under_test,
  #       template_file_path,
  #       expected_file_path,
  #       actual_file_path
  #   )

  end

  def common_test(markdown_helper, test_info)
    # p 'COMMON_TEST'
    # p test_info.method_under_test
    # p test_info.template_file_path
    # p test_info.actual_file_path
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
    command = "markdown_helper #{test_info.method_name} #{options} #{test_info.template_file_path} #{test_info.actual_file_path}"
    system(command)
    output = File.read(test_info.actual_file_path)
    diffs = MarkdownHelperTest.diff_files(test_info.expected_file_path, test_info.actual_file_path)
    unless diffs.empty?
      puts 'Expected:'
      puts File.read(expected_file_path)
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
