

class Profile
    def initialize concepts, file=nil
        @concepts = concepts
        @features = concepts.inject([]) do |l,c|
            c.features ? l + c.features : l
        end
        if file
            File.open file do |f| 
                instance_eval f.read 
            end
        end
        @parser = Parser.new *concepts
    end


    attr_reader :parser, :concepts, :features
end

class String
    def to_expr
        e = $profile.parser.parse self
        e.path = []
        e
    end
end

