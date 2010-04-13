require 'integer.rb'
describe "Integer module" do
    it "provides IntegerExpr class" do
        defined?(IntegerExpr).should == "constant"
        IntegerExpr.class.should == Class
        IntegerExpr.superclass.should == NullaryExpr
    end
    it "parses integers" do
        "3".to_expr.should == IntegerExpr.new(3)
        "-3".to_expr.should == IntegerExpr.new(-3)
        "0".to_expr.should == IntegerExpr.new(0)
    end
    it "does no canonization" do
        "3".to_expr.canonize.should == "3".to_expr
        "-3".to_expr.canonize.should == "-3".to_expr
    end
    it "typesets integers as they are"
    it "supports no transforms"
end
