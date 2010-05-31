
describe "Expression manipulation system" do
    before do
        @e = "1+2+3=a+b".to_expr
        @e2 = "a=b&&c=d".to_expr
    end

    it "can clone expressions correctly" do
        f=@e.deep_clone
        @e.should.equal? @e
        @e.should_not.equal? f
        @e[:a].should_not.equal? f[:a]
        @e[:b].should_not.equal? f[:b]
        @e[:a,0].should_not.equal? f[:a,0]
        @e[:a,1].should_not.equal? f[:a,1]
        @e[:a,2].should_not.equal? f[:a,2]
        @e[:b,0].should_not.equal? f[:b,0]
        @e[:b,1].should_not.equal? f[:b,1]

        f2=@e2.deep_clone
        @e2.should.equal? @e2
        @e2.should_not.equal? f2
        @e[0].should_not.equal? f[0]
        @e[1].should_not.equal? f[1]
        @e[0,:a].should_not.equal? f[0,:a]
        @e[0,:b].should_not.equal? f[0,:b]
        @e[1,:a].should_not.equal? f[1,:a]
        @e[1,:b].should_not.equal? f[1,:b]

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
        f = @e.deep_clone
        f.swap
        f.should == "a+b=1+2+3".to_expr
        @e.should == "1+2+3=a+b".to_expr

        f2 = @e2.deep_clone
        f2[0].swap
        f2.should == "b=a&&c=d".to_expr
        @e2.should == "a=b&&c=d".to_expr
    end


end
