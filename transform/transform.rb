class Transform < Struct.new(:display, :targets, :selected, :result)
    # display is what you see
    # targets are the subexpressions whose centers are averaged
    # selected are the subexpressions that are highlighted
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


