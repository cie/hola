require "tests/lovely.rb"
require "loader.rb"

if true
    $lovely = true
    $classes -= [
        RDParser, RDParser::LexToken, RDParser::Rule,
        #MElement, MO, MI, MN, MStack, MFlow, MCol, MRow, MSimpleElement, MContainer,
        #Typesetter,
    ]
    Lovely::start
end

tests = Dir.glob("tests/**/*_test.rb")

tests.each do |x|
    require x
end

describe "Tests" do
    it "called every method" do
        p $good_methods
        Lovely::print
        $good_methods.size.should == $methods.size
    end

end

