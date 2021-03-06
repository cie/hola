
class EquationExpr < BinaryExpr
    def initialize a,b,stands
        super a,b
        @stands = stands
    end
    attr_reader :stands
    def == other
        super and other.stands == @stands
    end
    

    def to_s
        "#{@a}#{operator}#{@b}"
    end

    def inspect
        "#{@a.inspect}#{operator}#{@b.inspect}"
    end

    def operator
        @stands ? "=" : "!="
    end

    def deep_clone
        self.class.new @a.deep_clone, @b.deep_clone, @stands
    end

    grammar do
        binary_operator(30, '==') {|a,b| EquationExpr.new a,b,true}
        binary_operator(30, '=') {|a,b| EquationExpr.new a,b,true}
        binary_operator(30, '!=') {|a,b| EquationExpr.new a,b,false}
    end

    typesetter do 
        mrow do
            expr @a
            mo @stands ? "=" : "≠"
            expr @b
        end
    end

    features [
        symmetric,
        compatible_with("AdditionExpr"),
    ]

end


