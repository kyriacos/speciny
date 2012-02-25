require 'test/unit'
require File.expand_path('../../lib/speciny', __FILE__)
#require 'lib/speciny'

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
  end

  def test_that_assertion_can_fail
    assert_raise(AssertionError) do
      1.should == 2
    end
  end

  #def test_comparison_object
    #assert_raise(AssertionError) do
      ##2.should have(4)
    #end
  #end
end
