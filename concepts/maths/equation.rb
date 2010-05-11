
class EquationExpr < BinaryExpr
    def initialize a,b,stands
        super a,b
        @stands = stands
    end
    attr_reader :stands

    def to_s
        "#{@a}#{operator}#{@b}"
    end

    def inspect
        "#{@a.inspect}#{operator}#{@b.inspect}"
    end

    def operator
        @stands ? "==" : "!="
    end

    grammar do
        binary_operator(30, '==') {|a,b| EquationExpr.new a,b,true}
        binary_operator(30, '!=') {|a,b| EquationExpr.new a,b,false}
    end

    typesetter do |app|
        @a.typeset app
        app.para stands ? "=" : "≠"
        @b.typeset app
    end
        
end


