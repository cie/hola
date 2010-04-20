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

    def operator *args
        args.each do |o|
            token(Regexp.new(Regexp.escape(o))) {|x|x}
        end
    end

    def binary_operator p, o, &block
        operator o
        priority p do
            match(higher, o, higher) {|a,_,b| yield a,b}
        end
    end

    def prefix_operator p, o, &block
        operator o
        priority p do
            match(p, higher) {|_,b| yield b}
        end
    end

    def nary_operator p, o, clazz, &block
        block ||= lambda {|x|x}
        operator o
        priority p do
            match(same, o, higher) { |a,_,b| a.is_a?(clazz) ? a << yield b : clazz.new([yield a, yield b]) }
        end
    end
            


end



class String
    def to_expr
        $parser.parse self
    end
end
