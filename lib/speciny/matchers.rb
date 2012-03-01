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

  # first way of doing the expect method
  # and catching and handling exceptions in
  # the matches method of raise_error
  #def expect(&block)
    #block
  #end

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

