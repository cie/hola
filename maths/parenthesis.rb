class ParenthesisExpr < UnaryExpr
    def initialize val
        @val = val
    end
    attr_reader :val

    def to_s
        %{(#{@val})}
    end

    grammar do
        operator "(", ")"
        priority 100 do
            match("(", expr, ")") { |_,x,_| ParenthesisExpr.new(x) }
        end
    end
        
end




