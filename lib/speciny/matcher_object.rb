module Speciny
  class MatcherObject
    attr_reader :actual, :matcher, :result
    def initialize(actual, matcher=nil, &block)
      @actual = actual
      @expected = @matcher = matcher
      @result = false
    end

    def run!
      @matcher ? self.matches? : self
    end

    def ==(other)
      @expected = other
      @result = @actual == other
      handle_result
    end

    def matches?
      @result = @matcher.matches?(@actual)
      handle_result
    end

    def handle_result
      @result ? @result : fail_with_message(@expected, @actual)
    end

    def fail_with_message(expected, actual)
      puts "-" * 10
      puts "Expected: #{expected}\nInstead got: #{actual}"
      puts "-" * 10
      raise Speciny::MatchError
    end

  end

  class PositiveMatcherObject < MatcherObject
  end

  class NegativeMatcherObject < MatcherObject
    def handle_result
      @result = !@result
      super
    end
  end
end
