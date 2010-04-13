require '../expr/expr.rb'
require '../parser/parser.rb'

class VariableExpr < NullaryExpr
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

Parser.rule 20 do |c,n|
    match /[a-zA-Z]+/ { |x| VariableExpr.new(x) }
end



