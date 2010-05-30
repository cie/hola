
describe "Expression manipulation system" do
    before do
        @e = "1+2+3=a+b".to_expr
        @e.path=[]
    end

    it "can swap binary expressions" do
        @e.swap
        @e.should == "a+b=1+2+3".to_expr
    end

    it "updates paths correctly after a swap" do
        @e.swap
        @e.a.path.should == [:a]
        @e.b.path.should == [:b]
    end

    it "does not care for paths when checking expression equalities" do
        @e="a+b=a+b".to_expr
        @e.a.should == @e.b
        @e="a+a".to_expr
        @e[0].should == @e[1]
    end

end
