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

  def test_link
    [
        ['# Foo', [1, '[Foo](#foo)']],
        ['# Foo Bar', [1, '[Foo Bar](#foo-bar)']],
        ['## Foo Bar', [2, '[Foo Bar](#foo-bar)']],
        ['### Foo Bar', [3, '[Foo Bar](#foo-bar)']],
        ['#### Foo Bar', [4, '[Foo Bar](#foo-bar)']],
        ['##### Foo Bar', [5, '[Foo Bar](#foo-bar)']],
        ['###### Foo Bar', [6, '[Foo Bar](#foo-bar)']],
        [' # Foo Bar', [1, '[Foo Bar](#foo-bar)']],
        ['  # Foo Bar', [1, '[Foo Bar](#foo-bar)']],
        ['   # Foo Bar', [1, '[Foo Bar](#foo-bar)']],
        ['#  Foo', [1, '[Foo](#foo)']],
        ['# Foo#', [1, '[Foo#](#foo)']],
    ].each do |pair|
      text, expected = *pair
      expected_level, expected_link = *expected
      heading = MarkdownHelper::Heading.parse(text)
      assert_equal(expected_level, heading.level)
      assert_equal(expected_link, heading.link)
    end
    [
        '',
        '#',
        '#Foo',
        '####### Foo Bar',
        '    # Foo Bar',
    ].each do |text|
      refute(MarkdownHelper::Heading.parse(text))
    end
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
      :actual_file_path

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
      :treatment,
      :include_file_path

    def initialize(file_stem, file_type, treatment)
      self.file_stem = file_stem
      self.file_type = file_type
      self.treatment = treatment
      self.md_file_basename = "#{file_stem}_#{treatment}"
      self.include_file_path = "../includes/#{file_stem}.#{file_type}"
      super(:include)
    end

  end

  class CreatePageTocInfo < TestInfo

    def initialize(md_file_basename)
      self.md_file_basename = md_file_basename
      super(:create_page_toc)
    end

  end

  def test_include

    # Create the template for this test.
    def create_template(test_info)
      File.open(test_info.template_file_path, 'w') do |file|
        case
        when test_info.file_stem == :nothing
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
          :pre,
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
      common_test(MarkdownHelper.new({:pristine => true}), test_info)
    end

    # Test invalid page TOC title.
    test_info = IncludeInfo.new(
        'invalid_title',
        :md,
        :page_toc
    )
    assert_raises(MarkdownHelper::InvalidTocTitleError) do
      common_test(MarkdownHelper.new({:pristine => true}), test_info)
    end

    # # Test multiple page TOC.
    # test_info = IncludeInfo.new(
    #     'multiple',
    #     :md,
    #     :page_toc,
    #     )
    # assert_raises(MarkdownHelper::MultiplePageTocError) do
    #   common_test(MarkdownHelper.new({:pristine => true}), test_info)
    # end

    # # Test misplaced page TOC.
    # test_info = IncludeInfo.new(
    #     'misplaced',
    #     :md,
    #     :page_toc,
    #     )
    # assert_raises(MarkdownHelper::MisplacedPageTocError) do
    #   common_test(MarkdownHelper.new({:pristine => true}), test_info)
    # end

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
    common_test(MarkdownHelper.new(:pristine => true), test_info)

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
    e = assert_raises(MarkdownHelper::UnreadableInputError) do
      common_test(MarkdownHelper.new, test_info)
    end
    # assert_template_exception(test_info.template_file_path, e)
    assert_kind_of(MarkdownHelper::UnreadableInputError, e)
    expected_message = <<EOT
Could not read input file:
C:/Users/Burde/Documents/GitHub/markdown_helper/test/include/templates/no_such_markdown.md
EOT
    assert_equal(expected_message, e.message)

    # Test markdown (output) open failure.
    test_info = IncludeInfo.new(
        file_stem = 'nothing',
        file_type = 'md',
        treatment = :markdown,
    )
    # create_template(test_info)
    test_info.actual_file_path = File.join(
        File.dirname(test_info.actual_file_path),
        'nonexistent_directory',
        'nosuch.md',
    )
    assert_raises(Exception) do
      common_test(MarkdownHelper.new, test_info)
    end

    return

    # Test circular includes.
    test_info = IncludeInfo.new(
        file_stem = 'circular_0',
        file_type = 'md',
        treatment = :markdown,
    )
    create_template(test_info)
    expected_inclusions = MarkdownHelper::Inclusions.new
    # The outer inclusion.
    includer_file_path = File.join(
        TEST_DIR_PATH,
        'include/templates/circular_0_markdown.md'
    )
    cited_includee_file_path  = '../includes/circular_0.md'
    inclusion = MarkdownHelper::Inclusion.new(
        include_description = "@[:markdown](#{cited_includee_file_path})",
        includer_file_path,
        includer_line_number = 1,
        cited_includee_file_path,
        treatment
    )
    expected_inclusions.inclusions.push(inclusion)
    # The three nested inclusions.
    [
        [0, 1],
        [1, 2],
        [2, 0],
    ].each do |indexes|
      includer_index, includee_index = *indexes
      includer_file_name = "circular_#{includer_index}.md"
      includee_file_name = "circular_#{includee_index}.md"
      includer_file_path = File.join(
          TEST_DIR_PATH,
          "include/templates/../includes/#{includer_file_name}"
      )
      inclusion = MarkdownHelper::Inclusion.new(
          include_description = "@[:markdown](#{includee_file_name})",
          includer_file_path,
          includer_line_number = 1,
          cited_includee_file_path = includee_file_name,
          treatment
      )
      expected_inclusions.inclusions.push(inclusion)
    end
    e = assert_raises(MarkdownHelper::CircularIncludeError) do
      common_test(MarkdownHelper.new, test_info)
    end
    assert_circular_exception(expected_inclusions, e)

    # Test includee not found.
    test_info = IncludeInfo.new(
                               file_stem = 'includer_0',
                               file_type = 'md',
                               treatment = :markdown,
    )
    create_template(test_info)
    expected_inclusions = MarkdownHelper::Inclusions.new
    # The outer inclusion.
    includer_file_path = File.join(
        TEST_DIR_PATH,
        'include/templates/includer_0_markdown.md'
    )
    cited_includee_file_path = '../includes/includer_0.md'
    inclusion = MarkdownHelper::Inclusion.new(
        include_description = "@[:markdown](#{cited_includee_file_path})",
        includer_file_path,
        includer_line_number = 1,
        cited_includee_file_path,
        treatment
    )
    expected_inclusions.inclusions.push(inclusion)
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
          TEST_DIR_PATH,
          "include/templates/../includes/#{includer_file_name}"
      )
      inclusion = MarkdownHelper::Inclusion.new(
          include_description = "@[:markdown](#{includee_file_name})",
          includer_file_path,
          includer_line_number = 1,
          cited_includee_file_path = includee_file_name,
          treatment
      )
      expected_inclusions.inclusions.push(inclusion)
    end
    e = assert_raises(Exception) do
      common_test(MarkdownHelper.new, test_info)
    end
    assert_includee_missing_exception(expected_inclusions, e)

  end

  # Don't call this 'test_interface' (without the leading underscroe),
  # because that would make it an actual executable test method.
  def _test_interface(test_info)
    File.write(test_info.actual_file_path, '') if File.exist?(test_info.actual_file_path)
    yield
    diffs = diff_files(test_info.expected_file_path, test_info.actual_file_path)
    unless diffs.empty?
      puts 'EXPECTED'
      puts File.read(test_info.expected_file_path)
      puts 'ACTUAL'
      puts File.read(test_info.actual_file_path)
      puts 'END'
    end
    assert_empty(diffs, test_info.actual_file_path)
  end

  def common_test(markdown_helper, test_info)

    # API
    _test_interface(test_info) do
      markdown_helper.send(
          test_info.method_under_test,
          test_info.template_file_path,
          test_info.actual_file_path,
          )
    end

    # CLI
    _test_interface(test_info) do
      options = markdown_helper.pristine ? '--pristine' : ''
      File.write(test_info.actual_file_path, '')
      command = "markdown_helper #{test_info.method_under_test} #{options} #{test_info.template_file_path} #{test_info.actual_file_path}"
      system(command)
    end

  end

  def diff_files(expected_file_path, actual_file_path)
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

  def assert_inclusion_exception(expected_exception_class, exception_label, expected_inclusions, e)
    assert_kind_of(expected_exception_class, e)
    lines = e.message.split("\n")
    label_line = lines.shift
    assert_equal(exception_label, label_line)
    backtrace_line = lines.shift
    assert_equal(MarkdownHelper::Inclusions::BACKTRACE_LABEL, backtrace_line)
    level_line_count = 1 + MarkdownHelper::Inclusion::LINE_COUNT
    level_count = lines.size / level_line_count
    # Backtrace levels are innermost first, opposite of inclusions.
    reversed_inclusions = expected_inclusions.inclusions.reverse
    (0...level_count).each do |level_index|
      level_line = lines.shift
      inclusion_lines = lines.shift(MarkdownHelper::Inclusion::LINE_COUNT)
      assert_equal("#{MarkdownHelper::Inclusions::LEVEL_LABEL} #{level_index}:", level_line)
      expected_inclusion = reversed_inclusions[level_index]
      assert_lines(level_index, inclusion_lines, expected_inclusion)
    end
  end

  def assert_circular_exception(expected_inclusions, e)
    assert_inclusion_exception(
        MarkdownHelper::CircularIncludeError,
        MarkdownHelper::Inclusions::CIRCULAR_EXCEPTION_LABEL,
        expected_inclusions,
        e
    )
  end

  def assert_includee_missing_exception(expected_inclusions, e)
    assert_inclusion_exception(
        Exception,
        MarkdownHelper::Inclusions::MISSING_INCLUDEE_EXCEPTION_LABEL,
        expected_inclusions,
        e
    )
  end

  def assert_lines(level_index, actual_lines, expected_inclusion)
    level_label = "Level #{level_index}:"
    # Includer label.
    includee_label = actual_lines.shift
    assert_match(/^\s*Includer:$/, includee_label, level_label)
    # Includer locatioin.
    location = actual_lines.shift
    message = "#{level_label} includer location"
    assert_match(/^\s*Location:/, location, message)
    includer_realpath =  Pathname.new(expected_inclusion.includer_file_path).realpath.to_s
    relative_path = MarkdownHelper.path_in_project(includer_realpath)
    r = Regexp.new(Regexp.escape("#{relative_path}:#{expected_inclusion.includer_line_number}") + '$')
    assert_match(r, location, message)
    # Include description.
    description = actual_lines.shift
    message = "#{level_label} include description"
    assert_match(/^\s*Include description:/, description, message)
    r = Regexp.new(Regexp.escape("#{expected_inclusion.include_description}") + '$')
    assert_match(r, description, message)
    # Includee label.
    includee_label = actual_lines.shift
    assert_match(/^\s*Includee:$/, includee_label, level_label)
    # Includee file path.
    includee_file_path = actual_lines.shift
    message = "#{level_label} includee cited file path"
    assert_match(/^\s*File path:/, includee_file_path, message)
    relative_path = MarkdownHelper.path_in_project(expected_inclusion.absolute_includee_file_path)
    r = Regexp.new(Regexp.escape("#{relative_path}") + '$')
    assert_match(r, includee_file_path, message)
  end

end
