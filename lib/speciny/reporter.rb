module Speciny
  class Reporter

    def initialize(scenario)
      @scenario = scenario
      @passing, @failing, @pending = 0
    end

    # stupid needs refactoring
    def normalized_value?(returned)
      returned.respond_to?(:result) ?  returned.result : returned
    end

    def print_test_result(example, returned)
      puts "SCENARIO: #{@scenario}"
      result = normalized_value?(returned)
      puts "\t- #{example}"
      if result == true
        puts "\t\tPASSED"
        @passing += 1
      elsif result == false
        puts "\t\tFAILED"
        @failing += 1
      elsif result == :PENDING
        puts "\t\tPENDING"
        @pending += 1
      end
    end

    # Print out a summary of the test results
    #def print_summary
      #puts "-------------------------------"
      #puts "DESCRIBE:\t #{@scenario}"
      #puts "PASSING:\t #{@passing}"
      #puts "FAILING:\t #{@failing}"
      #puts "PENDING:\t #{@pending}"
      #puts "-------------------------------"
      ##puts "TOTAL TESTS: #{total_tests}"
    #end

    #def total_tests
      #@passing + @failing + @pending
    #end
  end
end
