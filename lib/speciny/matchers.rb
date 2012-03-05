module Matchers
  def have(value)
    Have.new(value)
  end

  def equal?(value)
    Equal.new(value)
  end

  def raise_error(value)
    Raise.new(value)
  end
  alias :raises_error :raise_error
    alias :fails_with :raise_error
    alias :fail_with :raise_error
    alias :fail_with_message :raise_error
    alias :raise_exception :raise_error

    def expect(&block)
      result = nil
      begin
        result = block.call
      rescue Exception => e
        result = e
      ensure
        result
      end
      result
    end
end

module Speciny
  class Have
    attr_reader :value
    def initialize(value)
      @value = value
    end

    def items; self; end
    def things; self; end
    def characters; self; end

    def matches?(object)
      return object == self.value if object.kind_of?(Numeric)
      return object.length == self.value
      if object.respond_to?(:length)
      else
        object == self.value
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

  class Raise
    attr_reader :value
    def initialize(value)
      @value = value
    end

    def matches?(object)
      if self.value.kind_of?(String) && object.respond_to?(:message)
        self.value == object.message
      else
        # if they have the same exception class
        self.value == object.class
      end
    end
  end
end
