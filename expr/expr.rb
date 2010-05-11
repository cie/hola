class Expr
    def self.grammar &block
        @grammar = block unless block.nil?
        @grammar || (superclass != Expr ? superclass.grammar : lambda {|x|x})
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
    def initialize a,b
        @a = a
        @b = b
    end
    attr_reader :a, :b

    class << self
        attr_accessor :operator, :priority
    end

    grammar do |subclass|
        binary_operator(subclass.priority, subclass.operator) {|a,b| subclass.new a,b}
    end
end

class NaryExpr < Expr
    def initialize val
        @val = val
    end
    attr_reader :val

    class << self
        attr_accessor :priority
    end

    def << a
        @val << a
        self
    end

    grammar do
        nary_operator(subclass.priority, subclass.plus, subclass) {|a,b| a.is_a?(subclass) ? a << b : subclass.new([a,b]) }
    end

end

class AdditiveExpr < NaryExpr
    class << self
        attr_accessor :plus, :minus, :sign_priority
    end

    def to_s insp=false
        s=''
        val.enum_with_index do |x,i|
            if x[0]
                s << self.class.plus if i>0 || insp
            else
                s << self.class.minus
            end
            s << (insp ? x[1].inspect : x[1].to_s)
        end
        s
    end

    def inspect
        to_s true
    end

    grammar do |subclass|
        prefix_operator(subclass.sign_priority, subclass.plus) {|x| subclass.new([[true ,x]])}
        prefix_operator(subclass.sign_priority, subclass.minus) {|x| subclass.new([[false,x]])}
        nary_operator(subclass.priority, subclass.plus, subclass) {|a,b| a.is_a?(subclass) ? a << [true, b] : subclass.new([[true,a], [true,b]])}
        nary_operator(subclass.priority, subclass.minus, subclass) {|a,b| a.is_a?(subclass) ? a << [false, b] : subclass.new([[true,a], [false,b]])}
    end


end

