$:.unshift "."
require 'lib/speciny'

describe "Pending examples" do
  xit "should not execute if marked as pending" do
    raise StandardError
  end
end
