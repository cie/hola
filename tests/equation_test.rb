require 'expr/expr.rb'
require 'parser/parser.rb'
require 'concepts/maths/addition.rb'
require 'concepts/maths/variable.rb'
require 'concepts/maths/integer.rb'
require 'concepts/maths/equation.rb'
require 'concepts/maths/parenthesis.rb'

describe EquationExpr do
    describe "as a nice class" do
        it "supports ==" do
            EquationExpr.new(IntegerExpr.new(10), IntegerExpr.new(5), true).should ==
                EquationExpr.new(IntegerExpr.new(10), IntegerExpr.new(5), true)
            EquationExpr.new(IntegerExpr.new(10), IntegerExpr.new(5), false).should_not ==
                EquationExpr.new(IntegerExpr.new(10), IntegerExpr.new(5), true)
            EquationExpr.new(IntegerExpr.new(10), IntegerExpr.new(5), false).should_not ==
                EquationExpr.new(IntegerExpr.new(10), IntegerExpr.new(50), false)
            EquationExpr.new(IntegerExpr.new(10), IntegerExpr.new(5), false).should_not ==
                nil
        end
        it "provides good to_s" do
            %w{ a=b  a+b!=2  Apricot-R!=5  C+2=1  4=4  6=5 }.each do |x|
                x.to_expr.to_s.should == x
                x.gsub(/([^!])=/, '\1==').to_expr.to_s.should == x
            end
        end

    end

    describe "as a parser extension" do
        before do
            $parser = Parser.new AdditionExpr, IntegerExpr, VariableExpr, EquationExpr
        end

        it "can parse equalitites" do
            'a=b'.to_expr.should == EquationExpr.new(VariableExpr.new('a'), VariableExpr.new('b'), true)
            'a==b'.to_expr.should == EquationExpr.new(VariableExpr.new('a'), VariableExpr.new('b'), true)
        end

        it "can parse inequalities" do
            'a!=b'.to_expr.should == EquationExpr.new(VariableExpr.new('a'), VariableExpr.new('b'), false)
        end

        it "can parse inequalities" do
            'a!=b'.to_expr.should == EquationExpr.new(VariableExpr.new('a'), VariableExpr.new('b'), false)
        end

        it "can parse complex parenthesized expressions" do
            '+4-2+6!=(4+1)-(3+2-3)+(-1)'.to_expr.should == EquationExpr.new(
                AdditionExpr.new([[true , IntegerExpr.new(4)], [false, IntegerExpr.new(2)], [true , IntegerExpr.new(6)]]),
                AdditionExpr.new([
                                 [true , ParenthesisExpr.new('4+1'.to_expr)],
                                 [false, ParenthesisExpr.new('3+2-3'.to_expr)],
                                 [true , ParenthesisExpr.new('-1'.to_expr)]]),
                                 false)
        end

    end

    describe "as a transform extension" do
        it "provides commutativity" do
            e = 'a+2=b'.to_expr
            e.transforms(e.a).should == [
                MoveTransform.new('a+2=b'.to_expr, 'a+2'.to_expr),
            ]
        end
        it "provides compatibility with adition"
    end

end

