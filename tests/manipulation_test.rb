
describe "Expression manipulation system" do
    before do
        @e = "1+2+3=a+b".to_expr
        @e2 = "a=b&&c=d".to_expr
        @e3 = "a=b+(1)".to_expr
    end

    it "can clone expressions correctly" do
        f=@e.deep_clone!
        @e.should.equal? @e
        @e.should_not.equal? f
        @e[:a].should_not.equal? f[:a]
        @e[:b].should_not.equal? f[:b]
        @e[:a,0].should_not.equal? f[:a,0]
        @e[:a,1].should_not.equal? f[:a,1]
        @e[:a,2].should_not.equal? f[:a,2]
        @e[:b,0].should_not.equal? f[:b,0]
        @e[:b,1].should_not.equal? f[:b,1]

        f2=@e2.deep_clone!
        @e2.should.equal? @e2
        @e2.should_not.equal? f2
        @e2[0].should_not.equal? f2[0]
        @e2[1].should_not.equal? f2[1]
        @e2[0,:a].should_not.equal? f2[0,:a]
        @e2[0,:b].should_not.equal? f2[0,:b]
        @e2[1,:a].should_not.equal? f2[1,:a]
        @e2[1,:b].should_not.equal? f2[1,:b]

        f3=@e3.deep_clone!
        @e3.should.equal? @e3
        @e3.should_not.equal? f3
        @e3[:a].should_not.equal? f3[:a]
        @e3[:b].should_not.equal? f3[:b]
        @e3[:b,0].should_not.equal? f3[:b,0]
        @e3[:b,1].should_not.equal? f3[:b,1]
        @e3[:b,1,nil].should_not.equal? f3[:b,1,nil]
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
        f = @e.deep_clone!; f.path = []
        f.swap
        f.should == "a+b=1+2+3".to_expr
        @e.should == "1+2+3=a+b".to_expr

        f2 = @e2.deep_clone!; f2.path = []
        f2[0].swap
        f2.should == "b=a&&c=d".to_expr
        @e2.should == "a=b&&c=d".to_expr
    end

    it "can insert a new sub-expression" do
        @e[:b] = "6".to_expr
        @e.should == "1+2+3=6".to_expr
        @e.b.path.should == [:b]
        @e.b.parent.should.equal? @e
    end


end
