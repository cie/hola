class ParenthesisExpr < UnaryExpr
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
        mrow do
            mo "("
            expr @val
            mo ")"
        end
    end
        
        
end




