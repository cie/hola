class Expr
    def self.grammar &block
        @grammar = block if not block.nil?
        @grammar 
    end
end


class Parser < RDParser

    def initialize *exprclasses
        super() {}
        @priorities = {}

        # execute grammars (execute tokens, collect operators)
        exprclasses.each do |x|
            instance_exec &x.grammar
        end

        # ignore whitespace
        token(/\s+/) 

        # execute operators
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
            match(o, same) {|_,b| block.call b}
        end
    end

    def nary_operator p, o, &block # {|a,b| a.is_a?(MyselfExpr) ? a << b : MyselfExpr.new a,b}
        operator o
        priority p do
            match(same, o, higher) { |a,_,b| block.call a,b }
        end
    end
            


end




