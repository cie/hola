class Expr
    def == other
        other.is_a? self.class
    end

end

class NullaryExpr < Expr

end

class CompositeExpr < Expr
    #def each &block
end

class UnaryExpr < CompositeExpr
    def initialize val
        @val = val
    end
    attr_reader :val

    def == other
        super and other.val == @val
    end

    def each &block
        yield @val
    end
end

class BinaryExpr < CompositeExpr
    def initialize a,b
        @a = a
        @b = b
    end
    attr_reader :a, :b
    def == other
        super and other.a == @a and other.b == @b
    end

    def each &block
        yield @a
        yield @b
    end

end

class NaryExpr < CompositeExpr
    def initialize val
        @val = val
    end
    attr_reader :val
    def == other
        super and other.val == @val
    end

    class << self
        attr_accessor :priority
    end

    def << a
        @val << a
        self
    end

    def permute p
        @val.permute p
    end

    def each &block
        @val.each &block
    end

end


