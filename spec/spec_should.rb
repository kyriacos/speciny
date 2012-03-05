$:.unshift "."
require 'lib/speciny'

describe "Should" do
  it "should pass" do
    (1+2).should == 3
  end
end
