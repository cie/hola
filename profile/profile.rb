
class Profile
    def initialize expr_classes
        @expr_classes = expr_classes
        @parser = Parser.new *expr_classes
        @transformations = expr_classes.inject([]) do |l,c|
            c.transformations ? l + c.transformations : l
        end
    end


    attr_reader :parser, :expr_classes, :transformations
end

class String
    def to_expr
        e = $profile.parser.parse self
        e.path = []
        e
    end
end

