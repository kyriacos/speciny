module Kernel
  def should(matcher=nil, &block)
    MatcherObject.new(self, matcher, &block)
  end
end

module Kernel
  private
  def describe(description, &block)
    MatcherGroup.new(block).run!
  end
end

class MatcherGroup
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
  end

  def ==(other)
    raise AssertionError unless @subject == other
  end

end

class AssertionError < Exception
end
