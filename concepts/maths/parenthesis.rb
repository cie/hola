class ParenthesisExpr < UnaryExpr
    def initialize val
        @val = val
    end
    attr_reader :val

    def to_s
        %{(#{@val})}
    end

    def inspect
        %{(#{@val.inspect})}
    end

    grammar do
        operator "(", ")"
        priority 100 do
            match("(", expr, ")") { |_,x,_| ParenthesisExpr.new(x) }
        end
    end

    typesetter do
        mo "("
        mx @val
        mo ")"
    end
        
        
end




