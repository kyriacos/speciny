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

  scenario "Nested scenarios should have access to anything set in parent before block" do
    it "have access to parent variable" do
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
  def initialize(name="NoName"); @name = name; end
  def name; @name; end
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

scenario "defining multiple before(:each)" do
  before(:each) { @person = Person.new("kaks") }
  before(:each) { @another_person = Person.new }

  it "both should exist" do
    @person.name.should == "kaks"
    @another_person.name.should == "NoName"
  end
end
