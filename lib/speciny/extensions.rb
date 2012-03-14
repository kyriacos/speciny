module Kernel
  def should(matcher=nil, &block)
    Speciny::MatcherObject.new(self, matcher, &block)
  end
  alias :to :should
end

module Kernel
  private
  def describe(description, &block)
    Speciny::MatcherGroup.new(description, &block).run!
  end
  alias :context :describe
  alias :scenario :describe
end

