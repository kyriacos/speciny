module Speciny
  module Matchers

    def have(value); Have.new(value); end
    def equal(value); Equal.new(value); end

    def raise_error(value=nil); Raise.new(value); end
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

    class Have
      attr_reader :value
      def initialize(value)
        self.value = value
      end

      def items; self; end
      def things; self; end
      def characters; self; end

      def matches?(actual)
        return actual == self.value if actual.kind_of?(Numeric)
        if actual.respond_to?(:length)
          actual.length == self.value
        else
          actual == self.value
        end
      end
    end

    class Equal
      attr_reader :value
      def initialize(value)
        self.value = value
      end

      def matches?(actual)
        actual.equal?(self.value)
      end
    end

    class Raise
      attr_reader :value
      def initialize(value=nil)
        self.value = value
      end

      def matches?(actual)
        if self.value.kind_of?(String) && actual.respond_to?(:message)
          self.value == actual.message
        elsif actual.respond_to?(:message) && self.value.nil?
          # an exception was still raised
          true
        else
          # if they have the same exception class
          self.value == actual.class
        end
      end
    end
  end
end
