module Speciny
  class MatcherGroup
    include Matchers

    def initialize(block)
      @block = block
    end

    def run!
      instance_eval &@block
    end

    def it(description, &block)
      block.call
    end
  end

  class MatcherObject
    def initialize(subject, comparison=nil, &block)
      @subject = subject
      @comparison = comparison
      self.matches? if !comparison.nil?
    end

    def ==(other)
      raise Speciny::MatchError unless @subject == other
    end

    def matches?
      raise Speciny::MatchError unless @comparison.matches?(@subject)
    end
  end


  class MatchError < Exception
  end
end
