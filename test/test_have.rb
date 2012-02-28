require 'test/unit'
require File.expand_path('../../lib/have', __FILE__)

class TestHave < Test::Unit::TestCase
  #def test_have
    #assert_equal [1,2].length, have(5).matches?([1,2])
  #end

  def test_have_items
    a = [1,2,3,4,5]
    #assert_equal a.length, Have.new(5).items.length
    #assert_equal a.length, Handler.new(5).items
  end
end

class TestHandler < Test::Unit::TestCase
  def test_handler_calls_matches?
    matcher = Have.new(11).items
    object = "test string"
    handler = Handler.new(object, matcher)
    assert_equal true, handler.matches?
  end

  def test_handler_does_not_match
    matcher = Have.new(5).items
    object = "test"
    assert_equal false, Handler.new(object, matcher).matches?
  end
end
