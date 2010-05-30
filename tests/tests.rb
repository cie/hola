require "utils/lovely.rb"
require "loader.rb"

if true
    $lovely = true
    $classes -= [
        RDParser, 
        MElement, MO, MI, MN, MStack, MFlow, MCol, MRow, MSimpleElement, MContainer,
        Typesetter,

    ]
    Lovely::start
end

tests = Dir.glob("tests/**/*_test.rb")

tests.each do |x|
    require x
end

describe "Test suite" do
    it "tests all methods" do
        p $good_methods
        Lovely::print.size.should == 0
    end

end

