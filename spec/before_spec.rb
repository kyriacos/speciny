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

  scenario "Variables set in one example not available in other example" do
    before do
      @somevar = 12
    end

    it "sets an instance variable available to example" do
      @somevar.should == 12
    end

    it "should have access to parent before variables" do
      @somestring.should == "somestring"
    end
  end

  scenario "Each context has its local instance variables" do
    context "first context" do
      before(:each) do
        @first = 100
      end

      it "should have @first" do
        @first.should == 100
      end
    end

    context "second context" do
      before(:each) do
        @second = 200
      end

      it "should have @second" do
        @second.should == 200
      end

      it "should not have @first" do
        @first.should == nil
      end
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

  context "initialized in before(:each)" do
    it "has the default NoName" do
      @person.name.should == "NoName"
    end

    it "can change the name" do
      @person.name = "Kyriacos"
      @person.name.should == "Kyriacos"
    end

    it "should not share state with other examples" do
      @person.name.should == "NoName"
    end
  end
end
