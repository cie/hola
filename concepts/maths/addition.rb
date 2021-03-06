require 'expr/expr.rb'
require 'parser/parser.rb'

class AdditionExpr < NaryExpr

    S=0
    V=1

    def initialize val
        raise "nil subexpression: #{val.inspect}" if val.any?{|x|x[V].nil?}
        super
    end


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

    def each &block
        @val.map{|x|x[V]}.each &block
    end
    
    def path= p
        @path = p
        @val.enum_with_index do |e,i|
            e[V].path = p+[i]
            e[V].parent = self
        end
    end

    def remove pe
        super(pe)[V]
    end

    def [] *p
        if p.empty?
            self
        else
            @val[p.first][V][*p[1..-1]]
        end
    end

    def deep_clone
        self.class.new @val.map{|x|[x[S],x[V].deep_clone]}
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

    features [
        commutative,
        transpose { |pe,other|
            x = @val[pe]
            remove pe
            other.parent[other.path.last] = AdditionExpr.new [[!x[S],x[V]], [true, other]]
            x[V]
        },
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


