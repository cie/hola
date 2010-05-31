
class Expr

    class << self
        def transformations l=nil
            @transformations ||= []
            @transformations += l if l
            @transformations
        end
    end


    def transforms(sel)
        $profile.transformations.inject(
            [MoveTransform.new self, sel] # no-op transform
        ) do |l, tn|
            tn.transform self, sel do |t|
                l << t
            end
            l
        end 
    end
end

class BinaryExpr
    def self.commutative
        BinaryCommutativity.new self
    end
end


class Transformation
    def initialize exprclass
        @exprclass = exprclass
    end
    def transform expr, sel, &block
        if qualify(expr, sel)
            e = expr.deep_clone
            t = e[*sel.path]
            do_transform e, t
            yield transform_class.new(e, t)
        end
    end
end

module MoveTransformation
    def transform_class
        MoveTransform
    end
end

module SingleFeature
    def initialize exprclass
        @exprclass = exprclass
    end
end

class BinaryCommutativity < Transformation
    include MoveTransformation
    include SingleFeature
    def qualify e,s
        s.parent.is_a? @exprclass
    end
    def do_transform e,s
        s.parent.swap
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


