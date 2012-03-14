$:.unshift "."
require 'lib/speciny'

class Person; end

describe "Before block" do
  before do
    @somestring = "somestring"
  end

  it "should have access to instance variable in describe before block" do
    @somestring.should == "somestring"
  end

  context "Variables set in one example not available in other example" do
    before do
      @somevar = 12
    end

    it "sets an instance variable available to example" do
      @somevar.should == 12
    end

    it "variable in top context should be nil" do
      @somestring.should == nil
    end
  end

  context "Each context can have its own variables" do
    it "should not have variables from previous context" do
      @somevar.should == nil
    end
  end
end

class Person
  def name; @name ||= "NoName"; end
  def name=(value); @name = value; end
end

describe "before each" do
  before(:each) do
    @person = Person.new
  end

  #context "initialized in before(:each)" do
    it "has the default NoName" do
      p @person
      @person.name.should == "NoName"
    end

    it "can change the name" do
      @person.name = "Kyriacos"
      @person.name.should == "Kyriacos"
    end

    it "should not share state with other examples" do
      @person.name.should == "NoName"
    end
  #end
end
