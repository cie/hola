require 'expr/expr.rb'
require 'parser/parser.rb'
require 'concepts/maths/addition.rb'
require 'concepts/maths/variable.rb'
require 'concepts/maths/integer.rb'
require 'concepts/maths/equation.rb'
require 'concepts/maths/parenthesis.rb'
require 'transform/paths.rb'
require 'transform/manipulation.rb'

describe "Paths system" do
    before do
        @e = "1+2+3=a+b".to_expr
        @e.path=[]
    end

    it "gives correct paths" do
        @e.path.should == []
        @e.a.path.should == [:a]
        @e.b.path.should == [:b]
        @e.a.val[0][AdditionExpr::V].path.should == [:a,0]
        @e.a.val[1][AdditionExpr::V].path.should == [:a,1]
        @e.a.val[2][AdditionExpr::V].path.should == [:a,2]
        @e.b.val[0][AdditionExpr::V].path.should == [:b,0]
        @e.b.val[1][AdditionExpr::V].path.should == [:b,1]
    end

    it "can find sub-expressions by path" do
        @e[].should == @e
        @e[:a].should == @e.a
        @e[:b].should == @e.b
        @e[:a,0].should == @e.a.val[0][AdditionExpr::V]
        @e[:a,1].should == @e.a.val[1][AdditionExpr::V]
        @e[:a,2].should == @e.a.val[2][AdditionExpr::V]
        @e[:b,0].should == @e.b.val[0][AdditionExpr::V]
        @e[:b,1].should == @e.b.val[1][AdditionExpr::V]
    end

end

