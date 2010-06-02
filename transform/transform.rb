
class Expr

    class << self
        def features l=nil
            @features ||= []
            @features += l if l
            @features
        end
    end


    def transforms(sel)
        tee $profile.features.inject(
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

    def == other
        instance_variables.map{|k|instance_variable_get(k) == other.instance_variable_get(k)}.all?
    end

    def transform expr, sel, &block
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
    def initialize result, source, target
        super result, [target], [source, target], result
    end
end

class SimplifyTransform < Transform
end


