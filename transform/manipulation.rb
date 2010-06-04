class Expr 
    def deep_clone
        #x = self.class.allocate
        #instance_variables.each do |k|
            #if k != "@parent"
                #v = instance_variable_get(k)
                #if v.is_a? Expr
                    #v = v.deep_clone
                    #v.instance_variable_set("@parent", x)
                #elsif v.is_a? Array
                    #v = v.deep_clone
                #end
                #x.instance_variable_set(k,v) 
            #end
        #end
        #x

        clone
    end

    def deep_clone!
        e = deep_clone; e.path=[]
        e
    end
end

class Array
    #def deep_clone
        #map{|x| x.is_a?(Expr) ? x.deep_clone : x}
    #end
end

class BinaryExpr
    def deep_clone
        self.class.new @a, @b
    end
end

class NaryExpr
    def deep_clone
        self.class.new @val.map{|e|e.deep_clone}
    end
end

class UnaryExpr
    def deep_clone
        self.class.new @val.deep_clone
    end
end


class BinaryExpr
    def swap
        @a,@b = @b,@a
        self.path = path
    end
end

class NaryExpr
    def remove pe
        k = @val.delete_at pe
        self.path = path
        k
    end

    def permute! p
        @val.permute! p
        self.path = path
    end
end

