$:.unshift "."
require 'lib/speciny'

# this test i got from rspec
# https://www.relishapp.com/rspec/rspec-core/docs/helper-methods/let-and-let
# let defines a memoized helper method

$count = 0
describe "let" do

  let(:count) { $count += 1 }

  it "memoized the value" do
    count.should == 1
  end

  it "is not cached across examples" do
    count.should == 2
  end
end
