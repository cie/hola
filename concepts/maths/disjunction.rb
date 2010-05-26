
class DisjunctionExpr < NaryExpr

    def to_s
        @val.map{|x|x.to_s}.join('||')
    end

    def inspect
        @val.map{|x|x.inspect}.join('||')
    end

    grammar do
        nary_operator(10, '||') {|a,b| a.is_a?(DisjunctionExpr) ?
            a << b :
            DisjunctionExpr.new([a,b])}
    end

    typesetter do
        mflow do
            @val.each do |x|
                cell_expr x
            end
        end
    end

end





