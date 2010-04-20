require 'parser/rdparser.rb'


class Parser < RDParser

    def initialize *exprclasses
        super() {}
        @priorities = {}

        # execute grammars
        exprclasses.each do |x|
            if x.grammar.arity.zero?
                instance_exec &x.grammar
            else
                instance_exec x, &x.grammar
            end
        end

        # ignore whitespace
        token(/\s+/) 

        # execute priorites
        @priorities.keys.sort.each_with_index do |p,i|
            @i = i
            rule same do
                @priorities[p].each do |block|
                    instance_eval &block
                end
                match(higher) unless i == @priorities.size-1
            end
        end
        
        # set root rule
        @start = @rules[expr]
    end

    def priority p, &block
        @priorities[p] ||= []
        @priorities[p] << block
    end

    def token pattern, &block
        super
    end

    def level i
        "l#{i}".to_sym
    end

    def expr
        level 0
    end

    def same
        level @i
    end

    def higher
        level @i+1
    end

    def operator *args
        args.each do |o|
            token(Regexp.new(Regexp.escape(o))) {|x|x}
        end
    end

    def binary_operator p, o, &block
        operator o
        priority p do
            match(higher, o, higher) {|a,_,b| block.call a,b}
        end
    end

    def prefix_operator p, o, &block
        operator o
        priority p do
            match(o, higher) {|_,b| block.call b}
        end
    end

    def nary_operator p, o, clazz, &block
        operator o
        priority p do
            match(same, o, higher) { |a,_,b| a.is_a?(clazz) ? a << block.call(b) : clazz.new([block.call(a), block.call(b)]) }
        end
    end
            


end



class String
    def to_expr
        $parser.parse self
    end
end

