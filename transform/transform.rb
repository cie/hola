
class Expr
    def transformations
        @transformations ||= []
    end

    def transforms(sel)
        transformations.each do |t|
            t.transform self, sel do

            end
        end
    end
end

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
        super
        if sel.parent.is_a? @exprclass
            e = expr.clone
            t = e[sel.path]
            t.parent.swap
            yield MoveTransform.new(e, t)
        end
    end
end

class Transform < Struct.new(:expr, :targets, :result)
    #def targets
    #def result

end

class MoveTransform < Transform
    def initialize result, target
        super result, [target], result
    end

end

class CopyTransform < Transform
end

class SimplifyTransform < Transform
end


