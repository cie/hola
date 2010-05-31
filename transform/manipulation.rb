class Expr 
    def deep_clone
        x = self.class.allocate
        instance_variables.each do |k|
            if k != "@parent"
                v = instance_variable_get(k)
                if v.is_a? Expr
                    v = v.deep_clone
                    v.instance_variable_set("@parent", x)
                elsif v.is_a? Array
                    v = v.deep_clone
                end
                x.instance_variable_set(k,v) 
            end
        end
        x
    end
end

class Array
    def deep_clone
        map{|x| x.is_a?(Expr) ? x.deep_clone : x}
    end
end


class BinaryExpr
    def swap
        @a,@b = @b,@a
        self.path = path
    end
end
