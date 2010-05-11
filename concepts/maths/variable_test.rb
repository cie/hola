require 'concepts/maths/variable.rb'

describe VariableExpr do
    describe "as a nice class" do
        it "supports ==" do
            VariableExpr.new('d').should == VariableExpr.new('d')
            VariableExpr.new('d').should_not == VariableExpr.new('e')
            VariableExpr.new('d').should_not == VariableExpr.new('D')
            VariableExpr.new('d').should_not == nil
        end
    end

    describe "as a parser extension" do
        before do
            $parser = Parser.new(VariableExpr)
        end

        it "provides VariableExpr class" do
            defined?(VariableExpr).should == "constant"
            VariableExpr.class.should == Class
            VariableExpr.superclass.should == NullaryExpr
        end

        it "parses variables" do
            "a".to_expr.should == VariableExpr.new('a')
            "hello".to_expr.should == VariableExpr.new('hello')
            "Hello".to_expr.should == VariableExpr.new('Hello')
        end

        it "is case sensitive" do
            "Hello".to_expr.should_not == "hello".to_expr 
        end

        it "does no canonization" do
            "a".to_expr.canonize.should == "a".to_expr
            "hello".to_expr.canonize.should == "hello".to_expr
        end

    end

    describe "as a typesetter extension" do
        it "typesets variables as they are"
    end

    describe "as a transform extension" do
        it "supports no transforms"
    end

end
