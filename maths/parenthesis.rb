
require '../expr/expr.rb'
require '../parser/parser.rb'

class ParenExpr < UnaryExpr
    def initialize val
        @val = val
    end

    def to_s
        @val.to_s
    end

    def inspect
        %{##{@val}}
    end
end

Parser.rule 20 do |t,c,n|
    match "(", t, ")" { |_,x,_| ParenExpr.new(x) }
end



