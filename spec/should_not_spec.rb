$:.unshift "."
require 'lib/speciny'

describe "Should Not" do
  it "should pass" do
    (1+2).should_not == 2
  end

  it "should not have" do
    (1+2).should_not have(2).items
  end
end

