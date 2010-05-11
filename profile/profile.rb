
class Profile
    def initialize expr_classes, transform_classes
        @expr_classes = expr_classes
        @transform_classes = transform_classes
        @parser = Parser.new *expr_classes
    end

    attr_reader :parser, :expr_classes, :transform_classes
end

class String
    def to_expr
        $profile.parser.parse self
    end
end

