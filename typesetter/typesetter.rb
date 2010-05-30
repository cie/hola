class Expr
    def self.typesetter &block # { mrow { mo "("; expr @val; mo ")" } }
        @typesetter = block if not block.nil?
        @typesetter || (superclass != Expr ? superclass.typesetter : lambda {|x| error("Unimplemented typesetter")})
    end

    def typeset app, container, modules
        c = []
        Typesetter.typesetcell eqn.to_expr, c, modules
        m = c.first
        m.getdim!
        m.setlocdim([0,0], [container.width, container.height])
        m.render app
        m
    end

end

class Typesetter

    def self.typeset expr, container, modules
        t = self.new expr, container, modules
        m = t.instance_exec &expr.class.typesetter
        m.expr = expr
        modules.each {|x| m.extend x}
        m
    end

    def self.typesetcell expr, container, modules
        t = self.new expr, [], modules
        m = t.instance_exec &expr.class.typesetter
        m.expr = expr
        if not m.is_a? MResizable
            c = MCell.new
            c << m
            container << c
            modules.each {|x| m.extend x}
            c
        else
            container << m
            #modules.each {|x| m.extend x}
            m
        end
    end
        

    def initialize expr, container, modules
        expr.instance_variables.each { |v| instance_variable_set v, expr.instance_variable_get(v) }
        @containers = [container]
        @modules = modules
    end

    def _msimpleelement clazz, x
        m = clazz.new(x)
        @containers.last << m
        m
    end

    def mi x
        _msimpleelement MI, x
    end

    def mn x
        _msimpleelement MN, x
    end

    def mo x
        _msimpleelement MO, x
    end

    def _mcontainer clazz, &block
        r = clazz.new
        @containers.last << r
        @containers << r
        instance_exec &block
        return @containers.pop
    end

    def mrow &block
        _mcontainer MRow, &block
    end

    def mstack &block
        _mcontainer MStack, &block
    end

    def mflow &block
        _mcontainer MFlow, &block
    end

    def expr x
        m = self.class.typeset(x, @containers.last, @modules)
        m.path = x.path
        m
    end

    def cell_expr x
        m = self.class.typesetcell(x, @containers.last, @modules)
        m.path = x.path
        m
    end

end


