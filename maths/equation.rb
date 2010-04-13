
class EquationExpr < BinaryExpr
    def initialize a,b
        @a = a
        @b = b
    end

    attr_reader :a, :b

    def to_s
        "#{@a} = #{@b}"
    end

    def == other
        other.is_a?(self.class) && @a == other.a && @b == other.b
    end

    def self.grammar parser
        parser.token(/\=/) {|x|x}
        parser.operator 30 do
            match(lower, '=', lower) {|a,_,b| EquationExpr.new a,b}
            match(lower, '=', lower) {|a,_,b| EquationExpr.new a,b}
        end
    end
            
end


