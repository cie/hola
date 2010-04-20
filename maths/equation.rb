
class EquationExpr < BinaryExpr
    def initialize a,b,stands
        super a,b
        @stands = stands
    end
    attr_reader :stands

    def self.grammar parser
        parser.token(/\=/) {|x|x}
        parser.operator 30 do
            match(lower, '=', lower) {|a,_,b| EquationExpr.new a,b}
            match(lower, '=', lower) {|a,_,b| EquationExpr.new a,b}
        end
    end

    # --- new ---

    def to_s
        "#{@a}#{operator}#{@b}"
    end


    grammar do
        binary_operator(30, '==') {|a,b| EquationExpr.new a,b,true}
        binary_operator(30, '!=') {|a,b| EquationExpr.new a,b,false}
    end

            
end


