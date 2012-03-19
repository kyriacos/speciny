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
      raise Speciny::MatchError unless @result
      @result
      #fail_with_message(other, actual) unless @result
    end

    #def fail_with_message(expected, actual)
      #puts "-" * 10
      #puts "Expected: #{expected}\nInstead got: #{actual}"
      #puts "-" * 10
      ##raise Speciny::MatchError
    #end

    def matches?
      @result = @expected.matches?(@actual)
      raise Speciny::MatchError unless @result
      @result
    end
  end

  class PositiveMatcherObject < MatcherObject
  end

  class NegativeMatcherObject < MatcherObject
    def ==(other)
      #!super
      @result = !(@actual == other)
      raise Speciny::MatchError unless @result
      @result
      #fail_with_message(other, actual) unless @result
    end

    def matches?
      #!super
      @result = !(@expected.matches?(@actual))
      raise Speciny::MatchError unless @result
      @result
    end
  end
end
