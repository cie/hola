require 'parser/rdparser.rb'


class Parser < RDParser

    def initialize *exprclasses
        super() {}
        @operators = {}

        exprclasses.each {|x| x.grammar(self)}

        token(/\s+/) # ignore whitespace

        @operators.keys.sort.each_with_index do |prec,i|
            @i = i
            rule same do
                @operators[prec].each do |block|
                    instance_eval &block
                end
                match(lower) if i < @operators.size-1
            end
        end
        @start = @rules[expr]
    end

    def operator prec, &block
        @operators[prec] ||= []
        @operators[prec] << block
    end

    def token pattern, &block
        super
    end

    def expr
        :o0
    end

    def same
        "o#{@i}".to_sym
    end

    def lower
        "o#{@i+1}".to_sym
    end

end



class String
    def to_expr
        $parser.parse self
    end
end
