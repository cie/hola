class Expr
    def self.grammar &block
        @grammar ||= Grammar.new
        @grammar.instance_eval &block unless block.nil?
        @grammar
    end

    def == other
        other.is_a?(self.class) &&
            instance_variables.map{|x| 
            self.instance_variable_get(x) ==
                other.instance_variable_get(x)}.all?
    end
end

class NullaryExpr < Expr

end

class UnaryExpr < Expr

end

class BinaryExpr < Expr
    attr_reader :a, :b

    def == other
        other.is_a?(self.class) && @a == other.a && @b == other.b
    end

    class << self
        attr_accessor :operator, :priority
    end

end

class NaryExpr < Expr
    def initialize val
        @val = val
    end
    attr_reader :val

    def == other
        other.is_a?(self.class) && @val == other.val
    end

    def << a
        @val << a
        self
    end

end

class AdditiveExpr < NaryExpr
    class << self
        attr_accessor :plus, :minus
    end

    def to_s first_plus=false
        s=''
        val.enum_with_index do |x,i|
            if x[0]
                s << plus if i>0 || first_plus
            else
                s << minus
            end
            s << x[1].to_s
        end
        s
    end

    def inspect
        to_s true
    end

    grammar do |subclass|
        prefix_operator(80, subclass.plus) {|x| subclass.new([[true ,x]])}
        prefix_operator(80, subclass.minus) {|x| subclass.new([[false,x]])}
        nary_operator(50, subclass.plus, subclass) {|x| [true, x]}
        nary_operator(50, subclass.minus, subclass) {|x| [false, x]}
    end


end

