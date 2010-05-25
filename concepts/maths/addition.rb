require 'expr/expr.rb'
require 'parser/parser.rb'

class AdditionExpr < NaryExpr

    def to_s insp=false
        s=''
        val.enum_with_index do |x,i|
            if x[0]
                s << '+' if i>0 || insp
            else
                s << '-'
            end
            s << (insp ? x[1].inspect : x[1].to_s)
        end
        s
    end

    def inspect
        to_s true
    end

    grammar do
        prefix_operator(80, '+') {|x| AdditionExpr.new([[true, x]])}
        prefix_operator(80, '-') {|x| AdditionExpr.new([[false,x]])}
        nary_operator(50, '+') {|a,b| 
            a.is_a?(AdditionExpr) ?
                a << [true, b] : 
                AdditionExpr.new([[true,a], [true,b]])
        }
        nary_operator(50, '-') {|a,b| 
            a.is_a?(AdditionExpr) ? 
                a << [false,b] : 
                AdditionExpr.new([[true,a],[false,b]])
        }
    end

    typesetter do 
        mrow do
            @val.enum_with_index do |x,i|
                if x[0]
                    mo '+' if i>0 
                else
                    mo "−" # minus sign u2212
                end
                expr x[1]
            end
        end
    end

=begin
    transform do
        commutative
        associative
        invertible
    end

    def invert
        AdditionExpr.new([self], [false])
    end

    def permute p
        super
        @sgn.permute p
    end

=end


end


