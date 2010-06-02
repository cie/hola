
describe Permutation do
    it "can enumerate jumps" do
        Permutation.jumps(0,4).should == [
            [1,0,2,3],[1,2,0,3],[1,2,3,0]
        ]
        Permutation.jumps(2,4).should == [
            [2,0,1,3],[0,2,1,3],[0,1,3,2]
        ]
    end
    it "can permute arrays" do
        %w{a b c d e}.permute([4,1,0,2,3]).should == %w{e b a c d}
        %w{a b c d e}.permute!([4,1,0,2,3]).should == %w{e b a c d}
        a=%w{a b c d e}; a.permute!([4,1,0,2,3]); a.should == %w{e b a c d}
    end

end
