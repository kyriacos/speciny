module Speciny
  class MatcherGroup
    include Matchers

    def initialize(description, &block)
      @description = description
      @block = block
      @tests = {}
    end

    def run!
      instance_eval &@block
      finish
    end

    def it(description, &block)
      @tests[description] = returned = block.call
      print_result(description, returned)
    end

    def print_result(description, returned)
      result = result?(returned)
      puts "\t- #{description}"
      if result == true
        puts "\t\tPASSED"
      elsif result == false
        puts "\t\tFAILED"
      else
        puts "-------PENDING"
      end
    end

    def result?(returned)
      returned.respond_to?(:result) ?  returned.result : returned
    end

    def finish
      puts "DESCRIBE: #{@description}"
      passing_tests = 0
      failing_tests = 0
      total_tests = 0
      # add pending
      @tests.each do |description, returned|
        result?(returned) ? passing_tests +=1 : failing_tests += 1
        total_tests +=1
      end
      puts "PASSING: #{passing_tests}"
      puts "FAILING: #{failing_tests}"
      puts "TOTAL TESTS: #{total_tests}"
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
