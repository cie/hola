
describe "Expression manipulation system" do
    before do
        @e = "1+2+3=a+b".to_expr
        @e.path=[]
    end

    it "can clone expressions correctly" do
        f=@e.clone
        @e.should.equal? @e
        @e.should_not.equal? f
        @e[:a].should_not.equal? f[:a]
        @e[:b].should_not.equal? f[:b]
        @e[:a,0].should_not.equal? f[:a,0]
        @e[:a,1].should_not.equal? f[:a,1]
        @e[:a,2].should_not.equal? f[:a,2]
        @e[:b,0].should_not.equal? f[:b,0]
        @e[:b,1].should_not.equal? f[:b,1]
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

    it "can manipulate clones of expressions" do
        f = @e.clone
        f.swap
        f.should == "a+b=1+2+3".to_expr
        @e.should == "1+2+3=a+b".to_expr
    end


end
