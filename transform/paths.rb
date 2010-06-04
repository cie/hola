
class Expr

    def path
        @path || raise("Path unset: #{self}")
    end

    def parent
        @parent
    end

    attr_writer :parent, :path

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
    def []= pe, c
        @val = c if pe.nil?
        c.parent = self
        c.path = path + [pe]
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
    def []= pe,c
        @a = c if pe == :a
        @b = c if pe == :b
        c.parent = self
        c.path = path + [pe]
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
            @val[p.first][*p[1..-1]]
        end
    end
    def []= pe, c
        @val[pe] = c
        c.parent = self
        c.path = path + [pe]
    end
end



