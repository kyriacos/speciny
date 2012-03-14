$:.unshift "."
require 'lib/speciny'

describe "Before block" do
  before do
    @something = "something"
  end

  it "should have access to instance variable in describe before block" do
    @something.should == "something"
  end

  context "Variables set in one example not available in other example" do
    before do
      @itvariable = 12
    end

    it "sets an instance variable available to example" do
      @itvariable.should == 12
    end

    it "variable in top context should be nil" do
      @something.should == nil
    end
  end

  context "Each context can have its own variables" do
    it "should not have variables from previous context" do
      @itvariable.should == nil
    end
  end
end
