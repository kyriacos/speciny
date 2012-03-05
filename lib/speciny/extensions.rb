module Kernel
  def should(matcher=nil, &block)
    Speciny::MatcherObject.new(self, matcher, &block)
  end
end

module Kernel
  private
  def describe(description, &block)
    Speciny::MatcherGroup.new(description, &block).run!
  end
end

