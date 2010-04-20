require 'expr/expr.rb'
require 'parser/parser.rb'

class VariableExpr < NullaryExpr
    def initialize name
        @name = name
    end
    attr_reader :name

    def to_s
        @name
    end

    grammar do
        token(/[a-zA-Z]+/) {|m| VariableExpr.new m }
        priority 100 do
            match(VariableExpr)
        end
    end

end




