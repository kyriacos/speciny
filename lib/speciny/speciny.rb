module Speciny
  class MatcherGroup
    include Matchers

    attr_accessor :passing_tests,
                  :failing_tests,
                  :pending_tests

    def initialize(description, &block)
      @description = description
      @block = block
      @tests = {}
      @before = Hash.new { |order, values| order[values] = Array.new }
      # maybe change to instance variables to
      # calc the sum for total as well
      self.pending_tests = 0
      self.failing_tests = 0
      self.passing_tests = 0
    end

    # Got this idea from `bacon` another tiny rspec clone
    # When the instance exits it should print a summary on
    # the screen with the results.
    def self.summary_at_exit
      # `at_exit` is a ruby Kernel method available to all objects
      at_exit {
        print_summary
      }
    end

    # Executes block inside the MatcherGroup
    # and prints the result on screen
    def run!
      puts "DESCRIBE: #{@description}"
      # Have to evalute/execute the block on the instance
      instance_eval &@block
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

      print_test_result(description, returned)
    end

    # Pending examples
    # Just the simplest way i could do this i the time.
    # Couldn't think of a better way. Please contribute if you have one.
    def xit(description, &block)
      @tests[description] = block
      print_test_result(description, :PENDING)
    end

    # stupid needs refactoring
    def result?(returned)
      returned.respond_to?(:result) ?  returned.result : returned
    end

    def print_test_result(description, returned)
      result = result?(returned)
      puts "\t- #{description}"
      if result == true
        puts "\t\tPASSED"
        self.passing_tests += 1
      elsif result == false
        puts "\t\tFAILED"
        self.failing_tests += 1
      elsif result == :PENDING
        puts "\t\tPENDING"
        self.pending_tests += 1
      end
    end

    # Print out a summary of the test results
    def print_summary
      puts "-------------------------------"
      puts "DESCRIBE:\t #{@description}"
      puts "PASSING:\t #{passing_tests}"
      puts "FAILING:\t #{failing_tests}"
      puts "PENDING:\t #{pending_tests}"
      puts "-------------------------------"
      puts "TOTAL TESTS: #{@tests.count}"
    end
  end
end

module Speciny
  class MatcherObject
    attr_reader :actual, :expected, :result
    def initialize(actual, expected=nil, &block)
      @actual = actual
      @expected = expected
      @result = self.matches? if !expected.nil?
    end

    def ==(other)
      @result = @actual == other
    end

    def matches?
      @expected.matches?(@actual)
    end
  end
end
