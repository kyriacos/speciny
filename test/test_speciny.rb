$:.unshift "."

require 'pry'
require 'pry-nav'
require 'test/unit'
#require File.expand_path('../../lib/speciny', __FILE__)
require 'lib/speciny'

class TestSpeciny < Test::Unit::TestCase

  def test_describe_passing_empty
    describe ("empty with nothing pases") {}
  end

  def test_describe_passing_it
    describe "passing 'it' statement" do
      it "should pass" do
      end
    end
  end

  def test_describe_failing
    assert_raises(Exception) do
      describe "failing describe" do
        it "should raise an Exception" do
          raise Exception
        end
      end
    end
  end
end

class TestAssertion < Test::Unit::TestCase
  def test_that_assertion_can_pass
    2.should == 2
    #"test".should == "test"
  end

  def test_that_assertion_can_fail
    assert_raise(Error) do
      1.should == 2
    end
  end
end

class TestShouldHave < Test::Unit::TestCase
  def test_should_have_items
    [1,2,3].should have(3).items
  end

  def test_should_not_have_items
    assert_raise(Error) do
      [1,2,3].should have(4).items
    end
  end

  def test_should_have_things
    [1,2,3].should have(3).things
  end

  def test_should_not_have_things
    assert_raise(Error) do
      [1,2,3].should have(4).things
    end
  end

  def test_number_should_have_amount
    1.should have(1)
    2.should have(2).things
  end

  def test_number_should_not_have_wrong_amount
    assert_raise Error do
      1.should have(2)
      2.should have(1)
    end
  end

  def test_string_should_have
    describe "something" do
      it "should have" do
        "test".should have(4).characters
        #"test".should eql?("test")
        a = "test"
        a.should equal?(a)
      end
    end
  end

  def test_string_should_not_have
    assert_raise Error do
      "test".should have(5)
      "test".should have(5).characters
    end
  end

  #
  # and clean up?
end
