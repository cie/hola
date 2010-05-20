class Expr
    def self.typesetter &block # { mn @val }
        @typesetter = block if not block.nil?
        @typesetter || (superclass != Expr ? superclass.typesetter : lambda {|x| error("Unimplemented typesetter")})
    end


end

class MX < MRow
    def initialize expr
        super()
        @expr = expr
        Typesetter.new expr, self
    end
    def render app
        super
        @border = app.border app.red, opts.merge({:strokewidth => 1})
        @border.hide
    end
end

class Typesetter
    def initialize expr, container
        expr.instance_variables.each { |v| instance_variable_set v, expr.instance_variable_get(v) }
        @containers = [container]
        instance_exec &expr.class.typesetter
    end


    def mx x
        @containers.last << MX.new(x)
    end

    def mi x
        @containers.last << MI.new(x)
    end

    def mn x
        @containers.last << MN.new(x)
    end

    def mo x
        @containers.last << MO.new(x)
    end

    def mrow &block
        r = MRow.new
        @containers.last << r
        @containers << r
        instance_exec &block
        return @containers.pop
    end

end


