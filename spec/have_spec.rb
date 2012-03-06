$:.unshift "."
require 'lib/speciny'

describe "Have method" do
  it "should create a have object" do
    have(5).kind_of? Speciny::Matchers::Have
  end

  it "should have a value" do
    actual = have(5)
    5.should == actual.value
  end

  it "should respond and have characters" do
    "test".should have(4).characters
  end

  it "should have items and things" do
    "test".should have(4).items
    "test".should have(4).things
  end
end
