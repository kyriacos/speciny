$:.unshift "."
require 'lib/speciny'

describe "Be" do
  xit "should pass" do
    5.should be_equal?(5)
  end

  xit "should be greater than" do
    5.should be_greater_than(4)
  end
end
