module Selection
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

class MX
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
