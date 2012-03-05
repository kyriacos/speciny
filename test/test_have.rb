$:.unshift "."
require 'test/unit'
require 'lib/speciny/matchers'

class Havier < Speciny::Matchers::Have
end

class TestHave < Test::Unit::TestCase
  def test_have
    assert_equal [1,2].length, Havier.new(2).value
  end

  def test_have_items
    a = [1,2,3,4,5]
    assert_equal a.length, Havier.new(5).items.value
  end
end

