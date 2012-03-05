module Speciny
  class MatcherGroup
    include Matchers

    def initialize(description, &block)
      @description = description
      @block = block
      @tests = {}
    end

    def run!
      instance_eval &@block
      @tests.each do |description, returned|
        returned = returned.result if returned.respond_to?(:result)
        puts description
        if returned == true
          puts "\tPASSED"
        elsif returned == false
          puts "\tFAILED"
        else
          puts "\t--PENDING"
        end
      end
    end

    def it(description, &block)
      @tests[description] = block.call
    end
  end


  class MatcherObject
    attr_reader :subject, :comparison, :result
    def initialize(subject, comparison=nil, &block)
      @subject = subject
      @comparison = comparison
      @result = self.matches? if !comparison.nil?
    end

    def ==(other)
      #raise Speciny::MatchError unless @subject == other
      @result = @subject == other
    end

    def matches?
      #raise Speciny::MatchError unless @comparison.matches?(@subject)
      @comparison.matches?(@subject)
    end
  end


  class MatchError < Exception
  end
end
