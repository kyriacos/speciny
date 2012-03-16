module Speciny
  class MatcherGroup
    include Matchers

    def initialize(description, &block)
      @description = description
      @block = block
      @tests = {}
      @before = Hash.new { |order, values| order[values] = Array.new }
    end

    # When the instance exits it should print a summary on
    # the screen with the results.
    def summary_at_exit
      reporter = Speciny::Reporter.new(@description)
      @tests.each do |example, result|
        reporter.print_test_result(example, result)
      end
    end

    # Executes block inside the MatcherGroup
    # and prints the result on screen
    def run!
      # Have to evalute/execute the block on the instance
      instance_eval &@block
      summary_at_exit
    end

    # Defines a helper method for a supplied block, given a name.
    # Can be used instead of defining instance variables in the tests.
    def let(name, &block)
      # This method needs to be defined on the singleton/eigenclass.
      #
      # The eigenclass can be accessed as:
      #
      #     eigenclass = class << self; self; end
      #
      # Since Ruby 1.9 however a singleton_class was introduced
      # which provides acess to the singleton of the object.
      #
      # If one were to use:
      #
      #      self.class.instance_eval do ... end
      #      self.class.class_eval do .. end
      #      self.class.send :define_method, name do
      #
      # The method would be defined on the class and would
      # persist across all the examples.
      # For instance:
      #
      #      describe "Some Example" do
      #        let(:hundred) { 100 }
      #        it "should exist" { hundred.should == 100 }
      #      end
      #      describe "Some Other Example" do
      #        # This example would pass, when it should fail.
      #        it "should exist" { hundred.should == 100 }
      #      end
      #
      # Since define_method is a private method, we use `send`
      # to access it.
      #
      # The method defines a variable which uses a Hash
      # to store the result of evaluating the `block` given.
      #
      # Again notice the supplied `block` needs to be evaluated
      # on the current instance, which is why we are using `instance_eval`
      singleton_class.send :define_method, name do
        @assignments ||= {}
        @assignments[name] = instance_eval &block
      end
    end

    # Used to create a setup before an example or all examples
    # are executed.
    #
    # It defaults to before(:each). Only that is supported at the minute.
    #
    # When we defined the `@before` variable we defined it as
    # a Hash with a key `order` and for each key we store an array
    # of blocks.
    # That means we can also have multiple before blocks for each
    # scenario we run if we wanted.
    #
    # i.e:
    #     before(:each) { @person = Person.new }
    #     before(:each) { @another_person = Person.new }
    #
    # Now both of this examples would be executed. See the specs in
    # before_spec.rb for more examples.
    def before(order=:each, &block)
      @before[order] << block
    end

    # Here i defined the context and aliased the `describe`
    # method so that any `describe` or `context` blocks nested
    # within context/describe are evaluated under it and
    # any `before` blocks are added and executed.
    #
    # If we did chose not to re-define/override the methods here
    # then the Kernel methods would be called instead and the example
    # would "run under" the instance of the parent `describe` scenario.
    #
    # In turn we would not be able to access the `before` blocks defined
    # in the parent as they would not exist.
    def context(description, &block)
      context = Speciny::MatcherGroup.new(description, &block)
      # Add all the `before` blocks to be executed if any where defined
      # higher up.
      #
      # For example consider the following spec:
      #
      #      describe "Before block" do
      #        before do
      #          @somestring = "somestring"
      #        end
      #
      #        it "should have access to instance variable 
      #            in describe before block" do
      #
      #          @somestring.should == "somestring"
      #
      #        end
      #
      #        scenario "Nested scenarios should have access to
      #                  anything set in parent before block" do
      #
      #          it "have access to parent variable" do
      #            @somestring.should == "somestring"
      #          end
      #
      #        end
      #      end
      #
      @before.each do |order, values|
        values.each { |before_block| context.before(order, &before_block) }
      end
      # Now call the `run!` method for the scenario
      context.run!
    end
    alias :describe :context
    alias :scenario :context

    # Normal examples
    def it(description, &block)
      # Run the example within a proc and store the result.
      #
      # Notice that we execute any `before(:each)` blocks, prior
      # to running the example.
      returned = proc do
        @before[:each].each { |b| instance_eval &b }
        block.call
      end.call
      @tests[description] = returned
    end

    # Pending examples
    #
    # Just the simplest way i could do this i the time.
    #
    # Couldn't think of a better way. Please contribute if you have one.
    def xit(description, &block)
      @tests[description] = :pending
    end
  end
end
