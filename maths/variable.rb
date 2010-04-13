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

    def inspect
        %{#{@name}}
    end

    def == other
        other.is_a?(self.class) && @name == other.name
    end

    def self.grammar parser
        parser.token(/[a-zA-Z]+/) {|m| VariableExpr.new m }
        parser.operator 100 do
            match(VariableExpr) { |a| a }
        end
    end
end




