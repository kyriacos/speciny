$:.unshift "."
require 'lib/speciny'

describe "Have method" do
  it "should create a have object" do
    have(5).kind_of? Speciny::Matchers::Have
  end

  it "should have a value" do
    subject = have(5)
    5.should == subject.value
  end

  it "should raise MatchError if the value the object are not equal" do
    #subject = have(5)
    #thrown = nil
    #begin
      #6.should == subject.value
    #rescue Exception => e
      #thrown = e
    #ensure
      #unless !thrown.nil? && thrown.kind_of?(Speciny::MatchError)
        #throw "Expected #{Speciny::MatchError} instead got #{thrown}"
      #end
    #end
  end

  it "should respond and have characters" do
    "test".should have(4).characters
  end

  it "should have items and things" do
    "test".should have(4).items
    "test".should have(4).things
  end
end
