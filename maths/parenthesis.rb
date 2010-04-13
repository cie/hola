
class ParenthesisExpr < UnaryExpr
    def initialize val
        @val = val
    end
    attr_reader :val

    def to_s
        %{(#{@val})}
    end

    def == other
        other.is_a?(self.class) && @val == other.val
    end

    def self.grammar parser
        parser.token(/\(/) { |m| m }
        parser.token(/\)/) { |m| m }
        parser.operator 100 do 
            match("(", expr, ")") { |_,x,_| ParenthesisExpr.new(x) }
        end
    end
end




