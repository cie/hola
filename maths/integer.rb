require '../expr/expr.rb'
require '../parser/parser.rb'

class IntegerExpr < NullaryExpr
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

Parser.add 20 do
    match /[0-9]+/ { |x| IntegerExpr.new(x.to_i) }
end



