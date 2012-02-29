class Raise

  attr_reader :value
  def initialize(value)
    @value = value
  end

  def matches?(object)
    thrown = nil
    begin
      object.call
    rescue Exception => e
      thrown = e.class
    ensure
      #unless !thrown.nil? && thrown.kind_of?(@value)
      unless thrown == @value
        throw "Expected #{@value} instead got #{thrown}"
      end
    end
  end
end
