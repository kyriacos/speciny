module Kernel
  def have(value)
    Have.new(value)
  end
end

class Have
  attr_reader :value
  def initialize(value)
    @value = value
  end

  def items; self; end
  def things; self; end
  def characters; self; end

  # what about numberS?
  def matches?(object)
    return object == self.value if object.kind_of?(Numeric)
    if object.respond_to?(:length)
      object.length == self.value
    else
      raise Error
    end
  end
end

class Equal
  attr_reader :value
  def initialize(value)
    @value = value
  end

  def matches?(object)
    object.equal?(self.value)
  end
end
