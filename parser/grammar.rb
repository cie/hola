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
    grammar do |subclass|
        nary_operator(subclass.priority, subclass.plus) {|a,b| a.is_a?(subclass) ? a << b : subclass.new([a,b]) }
    end
end

