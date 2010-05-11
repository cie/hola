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

    class << self
        attr_accessor :operator, :priority
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

end

