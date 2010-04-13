require 'expr/expr.rb'
require 'parser/parser.rb'
require 'maths/addition.rb'
require 'maths/variable.rb'
require 'maths/integer.rb'
require 'maths/parenthesis.rb'

describe ParenthesisExpr, " as a parser extension" do
    before do
        $parser = Parser.new AdditionExpr, IntegerExpr, VariableExpr, ParenthesisExpr
    end

    it "can parse a single parenthesized value" do
        '(4)'.to_expr.should == ParenthesisExpr.new(IntegerExpr.new(4))
    end

    it "can parse a parenthesized signed value" do
        '(-E)'.to_expr.should == ParenthesisExpr.new('-E'.to_expr)
        '(+E)'.to_expr.should == ParenthesisExpr.new('+E'.to_expr)
    end

    it "can parse a parenthesized complex addition" do
        '(4+2-3)'.to_expr.should == ParenthesisExpr.new('4+2-3'.to_expr)
        '(-4+2-3)'.to_expr.should == ParenthesisExpr.new('-4+2-3'.to_expr)
        '(+4+2-3)'.to_expr.should == ParenthesisExpr.new('4+2-3'.to_expr)
    end

    it "can parse a complex addition of parenthesized additions" do
        '(4+1)-(3+2-3)+(-1)'.to_expr.should ==
            AdditionExpr.new([
                             [true , ParenthesisExpr.new('4+1'.to_expr)],
                             [false, ParenthesisExpr.new('3+2-3'.to_expr)],
                             [true , ParenthesisExpr.new('-1'.to_expr)]])
    end





end
