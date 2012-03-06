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

    def run!
      puts "DESCRIBE: #{@description}"
      instance_eval &@block
      finish
    end

    def it(description, &block)
      @tests[description] = returned = block.call
      print_result(description, returned)
    end

    def xit(description, &block)
      @tests[description] = "pending"
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


  class MatcherObject
    attr_reader :subject, :comparison, :result
    def initialize(subject, comparison=nil, &block)
      @subject = subject
      @comparison = comparison
      @result = self.matches? if !comparison.nil?
    end

    def ==(other)
      #raise Speciny::MatchError unless @subject == other
      @result = @subject == other
    end

    def matches?
      #raise Speciny::MatchError unless @comparison.matches?(@subject)
      @comparison.matches?(@subject)
    end
  end


  class MatchError < Exception
  end
end
