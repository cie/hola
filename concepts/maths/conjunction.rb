
class ConjunctionExpr < NaryExpr

    def to_s
        @val.map{|x|x.to_s}.join('&&')
    end

    def inspect
        @val.map{|x|x.inspect}.join('&&')
    end

    grammar do
        nary_operator(20, '&&') {|a,b| a.is_a?(ConjunctionExpr) ?
            a << b :
            ConjunctionExpr.new([a,b])}
    end

    typesetter do
        mstack do
            @val.each do |x|
                cell_expr x
            end
        end
    end

    features [
        commutative,
    ]


end





