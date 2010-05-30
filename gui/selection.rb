module SelectionGUI
    def sel
        @sels.last if @sels
    end


    def select element
        @sels ||= []
        sel.deselect if sel
        @sels << element
        sel.select
    end

    def deselect element
        @sels -= [element]
        element.deselect
        sel.select
    end


end

module MSelectableElement
    def render app
        super
        hit.hover do
            app.select self
        end
        hit.leave do
            app.deselect self
        end
    end
    def update
        super
        hit.style opts
    end
end

class MElement

    # hit area for mouse events
    def hit
        @hit ||= @app.flow opts do
            #@app.border @app.red, :strokewidth=>1
            @border = @app.border COLORS[:sel], :strokewidth => 1
            @border.hide
        end
    end

    def select
        @border.show
    end

    def deselect
        @border.hide
    end
end

class MContainer
    def select
        super
        @elems.each{|e| e.color=COLORS[:sel] if !e.expr}
    end

    def deselect
        super
        @elems.each{|e| e.color=COLORS[e.defaultcolor] if !e.expr}
    end

end

class MSimpleElement
    def select
        super
        self.color=COLORS[:sel]
    end

    def deselect
        super
        self.color=COLORS[defaultcolor]
    end

end
    
class MCell
    def select
        @elems[0].select
    end
    def deselect
        @elems[0].deselect
    end
end
