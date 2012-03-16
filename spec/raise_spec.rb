$:.unshift "."
require 'lib/speciny'

class Testing
  def initialize; end
  def run; raise Exception; end
  def run_exceptionless; end
end

describe "Raise exception" do
  it "should pass if it raises exception" do
    expect { (2/0) }.should raise_error ZeroDivisionError
  end

  it "should pass if an object raises exception" do
    expect { Testing.new.run }.should fail_with Exception
  end

  it "should fail to pass if it raises an exception" do
    expect { Testing.new.run_exceptionless }.should_not fail_with Exception
  end

  #it "should fail to pass if an object doesnt raise an exception" do
    #expect {
      #expect { Testing.new.run_exceptionless }.should fail_with Exception
    #}.should fail_with Speciny::MatchError
  #end

end
