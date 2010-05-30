
describe ConjunctionExpr do
    describe "as a nice class" do
        it "supports ==" 

        it "provides good to_s" do
            %w{ a=b&&c=d a=b&&c=d&&e=f a=b&&(a=b&&c=d)&&e=f}.each do |x|
                x.to_expr.to_s.should == x
            end
        end
    end

    describe "as a parser extension" do
        before do
            $parser = Parser.new AdditionExpr, IntegerExpr, VariableExpr, EquationExpr, ConjunctionExpr
        end

        it "can parse conjunctions" 

    end

    describe "as a transform extension" do
        it "provides commutativity"
        it "provides associativity"
    end

    describe "as a typesetter extension" do
        it "typesets expressions in a stack" do
            e = "a=b&&b=c".to_expr
            m = Typesetter.typeset e, [], []
            m.should.is_a? MStack
            m.elems[0].should.is_a? MCell
            m.elems[0].elems[0].should.is_a? MRow
            m.elems[0].elems[0].elems[0].should.is_a? MI
            m.elems[0].elems[0].elems[2].should.is_a? MI
            m.elems[1].elems[0].should.is_a? MRow
            m.elems[1].elems[0].elems[0].should.is_a? MI
            m.elems[1].elems[0].elems[2].should.is_a? MI
            m.expr.should.equal? e
            m.elems[0].expr.should.equal? e[0]
            m.elems[0].elems[0].elems[0].expr.should.equal? e[0,:a]
            m.elems[0].elems[0].elems[2].expr.should.equal? e[0,:b]
            m.elems[1].expr.should.equal? e[1]
            m.elems[1].elems[0].elems[0].expr.should.equal? e[1,:a]
            m.elems[1].elems[0].elems[2].expr.should.equal? e[1,:b]
        end
    end

end




