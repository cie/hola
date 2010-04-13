require 'expr/expr.rb'
require 'parser/parser.rb'

class IntegerExpr < NullaryExpr
    def initialize val
        @val = val
    end
    attr_reader :val

    def to_s
        @val.to_s
    end

    def inspect
        %{##{@val}}
    end

    def == other
        other.is_a?(self.class) && @val == other.val
    end

    def self.grammar parser
        parser.token(/\d+/) {|m| IntegerExpr.new m.to_i }
        parser.operator 100 do 
            match(IntegerExpr) { |a| a }
        end
    end

end




