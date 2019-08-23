require 'test_helper'

class LinkTest < Minitest::Test

  include TestHelper

  def test_run_irb
    Dir.entries(RunIrbInfo.templates_dir_path).each do |entry|
      next if entry.start_with?('.')
      test_info = RunIrbInfo.new(entry)
      common_test(MarkdownHelper.new, test_info)
    end
  end

end
