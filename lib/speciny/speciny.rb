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
      self.pending_tests = 0
      self.failing_tests = 0
      self.passing_tests = 0
    end

    # Executes block inside the MatcherGroup
    # and prints the result on screen
    def run!
      #ia = self.instance_variables
      puts "DESCRIBE: #{@description}"
      instance_eval &@block
      #ia = self.instance_variables - ia
      #ia.each { |i| i.remove }
      finish
    end

    def let(name, &block)
      self.class.send :define_method, name do
        @assignments ||= {}
        @assignments[name] = instance_eval &block
      end
    end

    # refactor this to use each and all
    # one way woul be to load all setup blocks
    # as before_filters work in rails and execute them
    # in the right order
    # its somewhere in the patterns book
    # child.before -> parent.before -> parent.before
    # its a chain to be executed.
    # If there is a before each that is
    #
    def before(order=nil, &block)
      block.call
    end

    # Normal examples
    def it(description, &block)
      returned = proc do
        block.call
      end.call
      @tests[description] = returned
      print_result(description, returned)
    end

    # Pending examples
    def xit(description, &block)
      @tests[description] = block
      print_result(description, "pending")
    end

    def result?(returned)
      returned.respond_to?(:result) ?  returned.result : returned
    end

    def print_result(description, returned)
      result = result?(returned)
      puts "\t- #{description}"
      if result == true
        puts "\t\tPASSED"
        self.passing_tests += 1
      elsif result == false
        puts "\t\tFAILED"
        self.failing_tests += 1
      elsif result == "pending"
        puts "\t\tPENDING"
        self.pending_tests += 1
      end
    end

    def finish
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


#module Speciny
  #class ExampleGroup
    #def initialize(describe_class, description, &block)
      #@describe_class = describe_class
      #@description = description
      #@block = block
    #end

    #def run!
      #@describe_class.class.class_eval do
        #@block.call
      #end
    #end

  #end
#end
