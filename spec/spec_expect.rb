$:.unshift "."
require 'lib/speciny'

class TestExpect
  def self.add_two(a, b)
    a + b
  end

  def self.failing_method()
    raise Exception, "failed to work"
  end
end

# Executes a method and returns the result without failing
describe "Expect Method" do
  it "should execute the block and return the result" do
    expect { 1 + 1 }.should == 2
    expect { TestExpect.add_two(1, 3) }.should == 4
  end

  it "should return the exception and not fail" do
    expect { raise ArgumentError }.should raise_error(ArgumentError)
    expect { TestExpect.failing_method }.should raise_error("failed to work")
  end
end
