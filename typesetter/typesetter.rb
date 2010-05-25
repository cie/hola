class Expr
    def self.typesetter &block # { mrow { mo "("; expr @val; mo ")" } }
        @typesetter = block if not block.nil?
        @typesetter || (superclass != Expr ? superclass.typesetter : lambda {|x| error("Unimplemented typesetter")})
    end


end

class Typesetter

    def self.typeset expr, container
        t = self.new expr, container
        m = t.instance_exec &expr.class.typesetter
        m.expr = expr
        m.extend MSelectableElement
    end

    def self.typesetcell expr, container
        m = typeset expr, []
        unless m.is_a? MResizable
            c = MCell.new
            typeset expr, c
            container << c
        else
            typeset expr, container
        end
    end
        

    def initialize expr, container
        expr.instance_variables.each { |v| instance_variable_set v, expr.instance_variable_get(v) }
        @containers = [container]
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

    def expr x
        self.class.typeset(x, @containers.last)
    end


end


