module Matchers
  def have(value)
    Have.new(value)
  end

  def equal?(value)
    Equal.new(value)
  end

  def raise(value)
    Raise.new(value)
  end
end

