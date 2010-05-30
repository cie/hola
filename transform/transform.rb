
class Expr

    class << self
        attr_accessor :transformations
    end

    @@transformations = []

    def transforms(sel)
        @@transformations.inject(
            [MoveTransform.new self, sel] # no-op transform
        ) do |l, tn|
            tn.transform self, sel do |t|
                l << t
            end
        end 
    end
end

class BinaryExpr
    def self.commutative
        BinaryCommutativity.new self
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
            t = e[*sel.path]
            t.parent.swap
            yield MoveTransform.new(e, t)
        end
    end
end

class Transform < Struct.new(:display, :targets, :result)
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


