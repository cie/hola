require 'expr/expr.rb'
require 'parser/parser.rb'

class AdditionExpr < NaryExpr

    S=0
    V=1

    def to_s insp=false
        s=''
        val.enum_with_index do |x,i|
            if x[S]
                s << '+' if i>0 || insp
            else
                s << '-'
            end
            s << (insp ? x[V].inspect : x[V].to_s)
        end
        s
    end

    def inspect
        to_s true
    end

    #def each &block
        #@val.map{|x|x[1]}.each &block
    #end
    
    def path= p
        @path = p
        @val.enum_with_index do |e,i|
            e[V].path = p+[i]
            e[V].parent = self
        end
    end

    def [] *p
        if p.empty?
            self
        else
            @val[p.first][V][*p[1..-1]]
        end
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
                if x[S]
                    mo '+' if i>0 
                else
                    mo "−" # minus sign u2212
                end
                expr x[V]
            end
        end
    end

    transforms = [
        #commutative,
        #associative,
        #invertible,
    ]

=begin
    def invert
        AdditionExpr.new([self], [false])
    end

    def permute p
        super
        @sgn.permute p
    end

=end


end


