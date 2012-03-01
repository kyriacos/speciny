class Raise

  attr_reader :value
  def initialize(value)
    @value = value
  end

  def matches?(object)
    #thrown = nil
    #begin
      #object.call
    #rescue Exception => e
      #thrown = e.class
    #ensure
      ##unless !thrown.nil? && thrown.kind_of?(@value)
      #unless thrown == @value
        #throw "Expected #{@value} instead got #{thrown}"
      #end
    #end

    # there are two ways of going about this
    # have the matches method begin and rescue which is a good idea again
    # or the expect block should always anyway return the result it got
    # so why not also return the exceptions and just use matches? here
    # to check for equality
    # if a string was passed then check if the resulting object
    # responds to method message as Exception objects do and check
    # if they are equal
    # TODO: clean up and add regexp
    #       and obviously make the code better?
    if self.value.kind_of?(String) && object.respond_to?(:message)
      self.value == object.message
    else
      # if they have the same exception class
      self.value == object.class
    end
  end
end
