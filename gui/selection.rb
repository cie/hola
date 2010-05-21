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
