$:.unshift "."
require 'lib/speciny'

describe "multiple expectations" do
  scenario "if one of the defined expectations fails it should return the failure" do
    it "should not fail" do
      1.should_not == 2
      2.should == 2
    end
  end
end
