module Speciny
  class Reporter

    def initialize(scenario)
      @scenario = scenario
      @passing = @failing = @pending = 0
    end

    # stupid needs refactoring
    #def normalized_value?(returned)
      #returned.respond_to?(:result) ?  returned.result : returned
    #end

    def print_test_result(example, result)
      puts "SCENARIO: #{@scenario}"
      puts "\t- #{example}"

      case result
      when true
        puts "\t\tPASSED"
        @passing += 1
      when false
        puts "\t\tFAILED"
        @failing += 1
      when :pending
        puts "\t\tPENDING"
        @pending += 1
      end
    end
  end
end
