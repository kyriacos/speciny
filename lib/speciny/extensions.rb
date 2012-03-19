module Kernel
  def should(matcher=nil, &block)
    Speciny::PositiveMatcherObject.new(self, matcher, &block).run!
  end
  alias :to :should

  def should_not(matcher=nil, &block)
    Speciny::NegativeMatcherObject.new(self, matcher, &block).run!
  end
  alias :to_not :should_not
end

module Kernel
  private
    def describe(description, &block)
      Speciny::MatcherGroup.new(description, &block).run!
    end
    alias :context :describe
    alias :scenario :describe
end

