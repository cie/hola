class Expr
    def self.grammar &block
        @grammar = block if not block.nil?
        @grammar || (superclass != Expr ? superclass.grammar : lambda {|x|x})
    end
end

class BinaryExpr
    grammar do |subclass|
        binary_operator(subclass.priority, subclass.operator) {|a,b| subclass.new a,b}
    end
end

class NaryExpr
    grammar do
        nary_operator(subclass.priority, subclass.plus, subclass) {|a,b| a.is_a?(subclass) ? a << b : subclass.new([a,b]) }
    end
end

class AdditiveExpr
    grammar do |subclass|
        prefix_operator(subclass.sign_priority, subclass.plus) {|x| subclass.new([[true ,x]])}
        prefix_operator(subclass.sign_priority, subclass.minus) {|x| subclass.new([[false,x]])}
        nary_operator(subclass.priority, subclass.plus, subclass) {|a,b| a.is_a?(subclass) ? a << [true, b] : subclass.new([[true,a], [true,b]])}
        nary_operator(subclass.priority, subclass.minus, subclass) {|a,b| a.is_a?(subclass) ? a << [false, b] : subclass.new([[true,a], [false,b]])}
    end
end
