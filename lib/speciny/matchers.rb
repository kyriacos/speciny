module Matchers
  def have(value)
    Have.new(value)
  end

  def equal?(value)
    Equal.new(value)
  end
end

