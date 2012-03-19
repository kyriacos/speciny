module Speciny
  module Matchers

    def have(value); Have.new(value); end
    def be(value); Have.new(value); end
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
        @value = value
      end

      def items; self; end
      def things; self; end
      def characters; self; end

      def matches?(actual)
        return actual == value if actual.kind_of?(Numeric)
        if actual.respond_to?(:length)
          actual.length == value
        else
          actual == value
        end
      end
    end

    class Equal
      attr_reader :value
      def initialize(value)
        @value = value
      end

      def matches?(actual)
        actual.equal?(value)
      end
    end

    class Raise
      attr_reader :value
      def initialize(value=nil)
        @value = value
      end

      def matches?(actual)
        if value.kind_of?(String) && actual.respond_to?(:message)
          value == actual.message
        elsif actual.respond_to?(:message) && value.nil?
          # an exception was still raised
          true
        else
          # if they have the same exception class
          value == actual.class
        end
      end
    end
  end
end
