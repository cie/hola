
describe "Paths system" do
    before do
        @e = "1+2+3=a+(b)".to_expr
        @e2 = "a=b&&b=c".to_expr
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
        @e.b.val[1][AdditionExpr::V].val.path.should == [:b,1,nil]
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
        @e[:b,1,nil].should == @e.b.val[1][AdditionExpr::V].val
    end

    it "can tell parents" do
        @e.a.parent.should == @e
        @e.b.parent.should == @e
        @e.a[0].parent.should == @e.a
        @e.a[1].parent.should == @e.a
        @e.a[2].parent.should == @e.a
        @e.b[0].parent.should == @e.b
        @e.b[1].parent.should == @e.b
        @e.b[1,nil].parent.should == @e.b[1]
    end
end


describe "Paths system" do

    describe "on mathml elements" do
        before do
            @m = Typesetter.typeset "1+2+3=a+(b)".to_expr, [], []
            @m2 = Typesetter.typesetcell "a=b&&b=c".to_expr, [], []
        end

        it "gives correct paths" do
            @m.path.should == []
            @m.elems[0].path.should == [:a]
            @m.elems[2].path.should == [:b]
            @m.elems[0].elems[0].path.should == [:a,0]
            @m.elems[0].elems[2].path.should == [:a,1]
            @m.elems[0].elems[4].path.should == [:a,2]
            @m.elems[2].elems[0].path.should == [:b,0]
            @m.elems[2].elems[2].path.should == [:b,1]
            @m.elems[2].elems[2].elems[1].path.should == [:b,1,nil]

            @m2.path.should == []
            @m2.elems[0].elems[0].path.should == [0]
            @m2.elems[1].elems[0].path.should == [1]
            @m2.elems[0].elems[0].elems[0].path.should == [0,:a]
            @m2.elems[0].elems[0].elems[2].path.should == [0,:b]
            @m2.elems[1].elems[0].elems[0].path.should == [1,:a]
            @m2.elems[1].elems[0].elems[2].path.should == [1,:b]
        end

        it "can find sub-expressions by path" do
            @m[].should == @m
            @m[:a].should == @m.elems[0]
            @m[:b].should == @m.elems[2]
            @m[:a,0].should == @m.elems[0].elems[0]
            @m[:a,1].should == @m.elems[0].elems[2]
            @m[:a,2].should == @m.elems[0].elems[4]
            @m[:b,0].should == @m.elems[2].elems[0]
            @m[:b,1].should == @m.elems[2].elems[2]
            @m[:b,1,nil].should == @m.elems[2].elems[2].elems[1]

            @m2[].should == @m2
            @m2[0].should == @m2.elems[0].elems[0]
            @m2[1].should == @m2.elems[1].elems[0]
            @m2[0,:a].should == @m2.elems[0].elems[0].elems[0]
            @m2[0,:b].should == @m2.elems[0].elems[0].elems[2]
            @m2[1,:a].should == @m2.elems[1].elems[0].elems[0]
            @m2[1,:b].should == @m2.elems[1].elems[0].elems[2]
        end

    end
        


end

