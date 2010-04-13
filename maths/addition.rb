require 'expr/expr.rb'
require 'parser/parser.rb'

class AdditionExpr < AdditiveExpr
    def initialize val
        @val = val
    end

    attr_reader :val

    def to_s
        s=''
        val.enum_with_index do |x,i|
            if x[0]
                s << '+' if i>0
            else
                s << '-'
            end
            s << x[1].to_s
        end
        s
    end

    def == other
        other.is_a?(self.class) && @val == other.val
    end

    def << a
        @val << a
        self
    end
        

    def self.grammar parser
        parser.token(/\+/) {|x|x}
        parser.token(/-/) {|x|x}
        parser.operator 80 do
            match('-', lower) {|_,b| AdditionExpr.new([[false,b]])}
            match('+', lower) {|_,b| AdditionExpr.new([[true,b]])}
        end
        parser.operator 50 do
            match(same, '+', lower) { |a,_,b| a.is_a?(AdditionExpr) ? a << [true , b] : AdditionExpr.new([[true,a],[true ,b]]) }
            match(same, '-', lower) { |a,_,b| a.is_a?(AdditionExpr) ? a << [false, b] : AdditionExpr.new([[true,a],[false,b]]) }
        end
    end
            
            
end


