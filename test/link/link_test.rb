require 'test_helper'

class LinkTest < Minitest::Test

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
      heading = MarkdownIncluder::Heading.parse(text)
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
      refute(MarkdownIncluder::Heading.parse(text))
    end
  end

end
