require 'test_helper'

require 'markdown_helper/version'

class VersionTest < Minitest::Test

  def test_version
    refute_nil MarkdownHelper::VERSION
  end

end