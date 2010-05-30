
class BinaryExpr
    def commutative
        BinayCommutativity.new self.class
    end
end


class Transformation
    def transform expr, sel, &block
    end
end

class BinaryCommutativity < Transformation
    def initialize exprclass
        @exprclass = exprclass
    end

    def transform expr, sel, &block
        if sel.parent.is_a? @exprclass
            e = expr.clone
            t = e[sel.path]
            t.parent.swap
            yield MoveTransform.new(expr, sel, e, t)
        end
                
    end
end


Transform = Struct.new(
    :expr,
    :target, 
    :type, 
    :se
)
