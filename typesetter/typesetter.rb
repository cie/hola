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
        @hit = app.flow opts do
            @border = app.border COLORS[:sel], :strokewidth => 1
            @border.hide
        end
        @hit.hover do
            app.select self
        end
        @hit.leave do
            app.deselect self
        end
    end
    def select
        @border.show
        @elems.each{|e| e.color=COLORS[:sel] if e.is_a? MSimpleElement}
    end
    def deselect
        @border.hide
        @elems.each{|e| e.color=COLORS[e.defaultcolor] if e.is_a? MSimpleElement}
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


