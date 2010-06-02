
class Profile
    def initialize expr_classes
        @expr_classes = expr_classes
        @parser = Parser.new *expr_classes
        @features = expr_classes.inject([]) do |l,c|
            c.features ? l + c.features : l
        end
    end

    def update_parser
        @parser = Parser.new *expr_classes
    end



    attr_reader :parser, :expr_classes, :features
end

class String
    def to_expr
        e = $profile.parser.parse self
        e.path = []
        e
    end
end

