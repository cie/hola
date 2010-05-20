require 'expr/expr.rb'
require 'parser/parser.rb'
require 'concepts/maths/addition.rb'
require 'concepts/maths/variable.rb'
require 'concepts/maths/integer.rb'

describe AdditionExpr do
    describe "as a nice class" do
        it "supports ==" do
            AdditionExpr.new([true, IntegerExpr.new(5)]).should ==
                AdditionExpr.new([true, IntegerExpr.new(5)])
            AdditionExpr.new([true, IntegerExpr.new(5)]).should_not ==
                AdditionExpr.new([false, IntegerExpr.new(5)])
            AdditionExpr.new([true, IntegerExpr.new(5)]).should_not ==
                AdditionExpr.new([true, IntegerExpr.new(6)])
            AdditionExpr.new([true, IntegerExpr.new(5)]).should_not == nil
        end

        it "provides good to_s" do
            %w{ 4+126  2+r  Apricot-R  C+2  4+2-5+c  6+5-1+2 }.each do |x|
                x.to_expr.to_s.should == x
                ('+' + x).to_expr.to_s.should == x
                ('-' + x).to_expr.to_s.should == ('-' + x)
            end
        end
    end

    describe "as a parser extension" do
        before do
            $parser = Parser.new AdditionExpr, IntegerExpr, VariableExpr
        end

        it "can parse signs" do
            '-3'.to_expr.should == AdditionExpr.new([[false, IntegerExpr.new(3)]])
            '+4'.to_expr.should == AdditionExpr.new([[true , IntegerExpr.new(4)]])
        end

        it "can parse simple additions" do
            '4+2'.to_expr.should == AdditionExpr.new([[true , IntegerExpr.new(4)], [true , IntegerExpr.new(2)]])
            's+g'.to_expr.should == AdditionExpr.new([[true , VariableExpr.new('s')], [true , VariableExpr.new('g')]])
        end

        it "can parse simple subtractions" do
            '4-2'.to_expr.should == AdditionExpr.new([[true , IntegerExpr.new(4)], [false, IntegerExpr.new(2)]])
            's-g'.to_expr.should == AdditionExpr.new([[true , VariableExpr.new('s')], [false, VariableExpr.new('g')]])
        end

        it "supports <<" do
            x = AdditionExpr.new([])
            (x << [true, IntegerExpr.new(4)]).should == '+4'.to_expr
            x.should == '+4'.to_expr
            (x << [false, IntegerExpr.new(6)]).should == '4-6'.to_expr
            x.should == '4-6'.to_expr
        end


        it "can parse multiple addtitions/subtractions" do
            '4-2+6'.to_expr.should == AdditionExpr.new([[true , IntegerExpr.new(4)], [false, IntegerExpr.new(2)], [true , IntegerExpr.new(6)]])
        end

        it "can parse simple addtitions/subtractions with sign" do
            '+4-2'.to_expr.should == AdditionExpr.new([[true , IntegerExpr.new(4)], [false, IntegerExpr.new(2)]])
            '-4-2'.to_expr.should == AdditionExpr.new([[false, IntegerExpr.new(4)], [false, IntegerExpr.new(2)]])
        end

        it "can parse multiple addtitions/subtractions with sign" do
            '+4-2+6'.to_expr.should == AdditionExpr.new([[true , IntegerExpr.new(4)], [false, IntegerExpr.new(2)], [true , IntegerExpr.new(6)]])
            '-4-2+6'.to_expr.should == AdditionExpr.new([[false, IntegerExpr.new(4)], [false, IntegerExpr.new(2)], [true , IntegerExpr.new(6)]])
        end

        it "can parse expressions with multiple-digit numbers" do
            '+49-11+513'.to_expr.should == AdditionExpr.new([[true , IntegerExpr.new(49)], [false, IntegerExpr.new(11)], [true , IntegerExpr.new(513)]])
            '-49-11+513'.to_expr.should == AdditionExpr.new([[false, IntegerExpr.new(49)], [false, IntegerExpr.new(11)], [true , IntegerExpr.new(513)]])
        end


    end

    describe "as a typesetter extension" do
        it "typesets additions like their to_s"
    end

    describe "as a transform extension" do
        it "provides commutativity"
        it "provides associativity"
        it "provides transforms of additive unit"
    end

end



