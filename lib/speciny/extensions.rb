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

