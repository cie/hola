require 'expr/expr.rb'
require 'parser/parser.rb'

class VariableExpr < NullaryExpr
    def initialize name
        @name = name
    end
    attr_reader :name
    def == other
        super and @name == other.name
    end

    def to_s
        @name
    end

    def inspect
        @name
    end

    grammar do
        token(/[a-zA-Z]+/) {|m| VariableExpr.new m }
        priority 100 do
            match(VariableExpr)
        end
    end

    typesetter do
        mi @name
    end

end




