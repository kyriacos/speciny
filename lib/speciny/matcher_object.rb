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
      #raise Speciny::Error unless @result
      #fail_with_message(other, actual) unless @result
    end

    def fail_with_message(expected, actual)
      puts "-" * 10
      puts "Expected: #{expected}\nInstead got: #{actual}"
      puts "-" * 10
      #raise Speciny::Error
    end

    def matches?
      @expected.matches?(@actual)
    end
  end
end
