class Expr
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

end


