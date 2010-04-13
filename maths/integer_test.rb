require 'maths/integer.rb'

describe IntegerExpr, " as a nice class" do
    it "supports ==" do
        IntegerExpr.new(6).should == IntegerExpr.new(6)
        IntegerExpr.new(6).should_not == IntegerExpr.new(7)
        IntegerExpr.new(6).should_not == nil
    end
end

describe IntegerExpr, " as a parser extension" do
    before do
        $parser = Parser.new(IntegerExpr)
    end

    it "provides IntegerExpr class" do
        defined?(IntegerExpr).should == "constant"
        IntegerExpr.class.should == Class
        IntegerExpr.superclass.should == NullaryExpr
    end
    it "parses integers" do
        "3".to_expr.should == IntegerExpr.new(3)
        "13".to_expr.should == IntegerExpr.new(13)
        "1234".to_expr.should == IntegerExpr.new(1234)
        "0".to_expr.should == IntegerExpr.new(0)
    end
end

describe IntegerExpr, " as a canonizer extension" do
    it "does no canonization" do
        "3".to_expr.canonize.should == "3".to_expr
    end
end

describe IntegerExpr, " as a typesetter extension" do
    it "typesets integers as they are"
end

describe IntegerExpr, " as a transform extension" do
    it "supports no transforms"
end

