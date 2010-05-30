
class Expr
    attr_accessor :path
    attr_accessor :parent



    def [] *p
        self if p.empty?
    end
end

class UnaryExpr
    def path= p
        super
        @val.path = p+[nil]
        @val.parent = self
    end
    def [] *p
        if p.empty?
            self
        else
            @val[*p[1..-1]] if p.first.nil?
        end
    end
end

class BinaryExpr
    def path= p
        super
        @a.path = p+[:a]
        @b.path = p+[:b]
        @a.parent = self
        @b.parent = self
    end
    def [] *p
        if p.empty?
            self
        else
            case p.first
            when :a then @a[*p[1..-1]]
            when :b then @b[*p[1..-1]] 
            end
        end
    end

end

class NaryExpr
    def path= p
        super
        @val.enum_with_index do |e,i|
            e.path = p+[i]
            e.parent = self
        end
    end
    def [] *p
        if p.empty?
            self
        else
            Kernel::p p
            @val[p.first][*p[1..-1]]
        end
    end
end



