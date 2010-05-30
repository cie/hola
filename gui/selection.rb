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
        hit.click do
            begin
                app.startTransformation if self == app.sel
            rescue
                puts $!, $!.backtrace
            end
        end
    end
    def update
        super
        hit.style opts
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
