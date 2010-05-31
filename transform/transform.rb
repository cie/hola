
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


class Transformation
    def initialize exprclass
        @exprclass = exprclass
    end

end

module MoveTransformation
    def transform_class
        MoveTransform
    end
end



class Transform < Struct.new(:display, :targets, :selected, :result)
    # display is what you see
    # targets are whose centers are averaged
    # selected are the subexpressions which get highlighted
    # result is what the equation will become
end

class MoveTransform < Transform
    def initialize result, target
        super result, [target], [target], result
    end
end

class CopyTransform < Transform
end

class SimplifyTransform < Transform
end


