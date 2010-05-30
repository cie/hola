
module TransformationGUI

    def startTransformation
        s = @expr[*sel.path]
        @transforms = @expr.transforms(s)
        @displays = {}
        @win.clear do
            @transforms.each do |t|
                @displays[t] = flow do
                    t.typeset self, [width, height]
                end
                @displays[t].hide
            end
            setTransform @transforms[0]
        end
    end

    def findTransform point
        setTransform @transforms.min{|a,b|
            (a.spot - point).l2 <=> (b.spot - point).l2}
    end

    def setTransform t
        if t!=@transform
            @displays[@transform].hide if @transform
            @transform = t
            @displays[t].show
        end
    end

    def finishTransformation 
        expr = @transform.result
        @transform = nil
        open expr
    end

end
