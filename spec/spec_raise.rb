$:.unshift "."
require 'lib/speciny'

class Testing
  def initialize

  end
  def run()
    raise Exception
  end
end

describe "Raise exception" do
  #it "should pass if it raise exception" do
    ##lambda { raise Exception }.should raise Exception
    #lambda { (2/0) }.should raise ZeroDivisionError
  #end

  #it "should pass if an object raises exception" do
    #a = Testing.new
    #a.run.should raise Exception
  #end
  
  it "should pass if it raises an exception"

end
