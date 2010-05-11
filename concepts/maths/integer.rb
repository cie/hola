class IntegerExpr < NullaryExpr
    def initialize val
        @val = val
    end
    attr_reader :val

    def to_s
        @val.to_s
    end

    def inspect
        %{#{@val}}
    end

    grammar do
        token(/\d+/) {|m| IntegerExpr.new m.to_i }
        priority 100 do 
            match(IntegerExpr)
        end
    end

end




