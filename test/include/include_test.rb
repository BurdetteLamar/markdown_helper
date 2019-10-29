require 'diff-lcs'

require 'test_helper'

class IncludeTest < Minitest::Test

  include TestHelper

  def test_include

    # Test combinations of treatments and templates.
    {
        :nothing => :txt,
        :md => :md,
        :python => :py,
        :ruby => :rb,
        :text => :txt,
        # :text_no_newline => :txt,
        :xml => :xml,
    }.each_pair do |file_stem, file_type|
      [
          :markdown,
          :code_block,
          :comment,
          :pre,
          :details,
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

    # Test automatic page TOC.
    [
        :all_levels,
        :dup_headers,
        :embedded,
        :gappy_levels,
        :mixed_levels,
        :no_headers,
        :no_level_one,
        :includer,
        :nested_headers,
    ].each do |file_stem|
      test_info = IncludeInfo.new(
          file_stem,
          :md,
          :page_toc,
          )
      common_test(MarkdownHelper.new, test_info)
    end

    # Test invalid page TOC title.
    test_info = IncludeInfo.new(
        'invalid_title',
        :md,
        :page_toc
    )
    assert_raises(MarkdownIncluder::InvalidTocTitleError) do
      common_test(MarkdownHelper.new, test_info)
    end

    # Test multiple page TOC.
    test_info = IncludeInfo.new(
        'multiple',
        :md,
        :page_toc,
        )
    assert_raises(MarkdownIncluder::MultiplePageTocError) do
      common_test(MarkdownHelper.new, test_info)
    end

    # Test markdown as code block.
    test_info = IncludeInfo.new(
        file_stem = 'markdown_block',
        file_type = 'md',
        treatment = 'markdown',
        )
    create_template(test_info)
    common_test(MarkdownHelper.new, test_info)

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

    # Test empty file.
    test_info = IncludeInfo.new(
        file_stem = 'empty',
        file_type = 'md',
        treatment = :markdown,
    )
    common_test(MarkdownHelper.new, test_info)

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

    # Test unknown option.
    e = assert_raises(MarkdownHelper::OptionError) do
      markdown_helper = MarkdownHelper.new(:foo => true)
    end
    assert_equal('Unknown option: foo', e.message)

    # Test template open failure.
    test_info = IncludeInfo.new(
        file_stem = 'no_such',
        file_type = 'md',
        treatment = :markdown,
    )
    e = assert_raises(MarkdownHelper::UnreadableTemplateError) do
      common_test(MarkdownHelper.new, test_info)
    end
    path_in_project = MarkdownHelper.path_in_project(test_info.template_file_path)
    assert_template_exception(path_in_project, e)

    # Test markdown (output) open failure.
    test_info = IncludeInfo.new(
        file_stem = 'nothing',
        file_type = 'md',
        treatment = :markdown,
    )
    # create_template(test_info)
    test_info.actual_file_path = File.join(
        test_info.actual_dir_path,
        'nonexistent_directory',
        'nosuch.md',
    )
    assert_raises(Exception) do
      common_test(MarkdownHelper.new, test_info)
    end

    # Test circular includes.
    Dir.chdir(test_info.includes_dir_path) do
      test_info = IncludeInfo.new(
          file_stem = 'circular_0',
          file_type = 'md',
          treatment = :markdown,
          )
      create_template(test_info)
      expected_inclusions = []
      cited_includee_file_path  = '../includes/circular_0.md'
      inclusion = MarkdownIncluder::Inclusion.new(
          test_info.template_file_path,
          include_description = "@[:markdown](#{cited_includee_file_path})",
          includer_line_number = 1,
          treatment,
          cited_includee_file_path,
          expected_inclusions,
          )
      expected_inclusions = expected_inclusions.push(inclusion)
      # The three nested inclusions.
      [
          [0, 1],
          [1, 2],
          [2, 0],
      ].each do |indexes|
        includer_index, includee_index = *indexes
        includer_file_name = "circular_#{includer_index}.md"
        includee_file_name = "circular_#{includee_index}.md"
        inclusion = MarkdownIncluder::Inclusion.new(
            includer_file_name,
            include_description = "@[:markdown](#{includee_file_name})",
            includer_line_number = 1,
            treatment,
            cited_includee_file_path = includee_file_name,
            expected_inclusions,
            )
        expected_inclusions = expected_inclusions.push(inclusion)
      end
      e = assert_raises(MarkdownIncluder::CircularIncludeError) do
        common_test(MarkdownHelper.new, test_info)
      end
      assert_circular_exception(expected_inclusions, e)
    end

    # Test includee not found.
    test_info = IncludeInfo.new(
        file_stem = 'includer_0',
        file_type = 'md',
        treatment = :markdown,
        )
    Dir.chdir(test_info.includes_dir_path) do
      create_template(test_info)
      expected_inclusions = []
        cited_includee_file_path = '../includes/includer_0.md'
      inclusion = MarkdownIncluder::Inclusion.new(
          test_info.template_file_path,
          include_pragma = "@[:markdown](#{cited_includee_file_path})",
          includer_line_number = 1,
          treatment,
          cited_includee_file_path,
          expected_inclusions,
          )
      expected_inclusions.push(inclusion)
      # The three nested inclusions.
      [
          [0, 1],
          [1, 2],
          [2, 3],
      ].each do |indexes|
        includer_index, includee_index = *indexes
        includer_file_name = "includer_#{includer_index}.md"
        includee_file_name = "includer_#{includee_index}.md"
        includer_file_path = File.join(
            test_info.includes_dir_path,
            includer_file_name
        )
        inclusion = MarkdownIncluder::Inclusion.new(
            includer_file_path,
            include_pragma = "@[:markdown](#{includee_file_name})",
            includer_line_number = 1,
            treatment,
            cited_includee_file_path = includee_file_name,
            expected_inclusions,
            )
        expected_inclusions = expected_inclusions.push(inclusion)
      end
      e = assert_raises(MarkdownIncluder::UnreadableIncludeeError) do
        common_test(MarkdownHelper.new, test_info)
      end
      assert_includee_missing_exception(expected_inclusions, e)
    end

    # Test include code block with includes.
    test_info = IncludeInfo.new(
        file_stem = 'code_block_with_includes',
        file_type = 'md',
        treatment = :code_block,
        )
    create_template(test_info)
    common_test(MarkdownHelper.new, test_info)

    # Test include code block with hashmarks.
    test_info = IncludeInfo.new(
        file_stem = 'nested_code_with_hashmarks_page_toc',
        file_type = 'md',
        treatment = :markdown,
        )
    create_template(test_info)
    common_test(MarkdownHelper.new, test_info)

    # Test local and non-local includes.
    test_info = IncludeInfo.new(
        file_stem = 'local_and_nonlocal_includes',
        file_type = 'md',
        treatment = :markdown,
        )
    create_template(test_info)
    common_test(MarkdownHelper.new, test_info)

  end

end
