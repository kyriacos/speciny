$:.unshift "."
require 'lib/speciny'

describe "Have method" do
  it "should create a have object" do
    have(5).kind_of? Have
  end

  it "should have a value" do
    subject = have(5)
    5.should == subject.value
  end

  it "should raise an error if the value the object are not equal" do
    subject = have(5)
    thrown = nil
    begin
      6.should == subject.value
    rescue Error => e
      thrown = e
    ensure
      unless !thrown.nil? && thrown.kind_of?(Error)
        throw "Expected #{Error} instead got #{thrown}"
      end
    end
  end

  it "should respond to characters" do
    "test".should have(4).characters
  end
end
