

class MElement
    def center
        loc.extend(Vector) + dim.extend(Vector) / 2
    end
end

class Transform
    #def color
    #def spot
    def spot
        @spot
    end

    def typeset app, dim
        m = display.typeset app, dim, []
        selected.each do |t|
            mt = m[*t.path]
            mt.selcolor = color
            mt.select
        end
        s = [0,0].extend(Vector)
        targets.each do |t|
            mt = m[*t.path]
            s += mt.center
        end
        m.hit.motion do |x,y|
            app.findTransform [x,y]
        end
        m.hit.release do
            app.finishTransformation
        end
        @spot = s / targets.size
    end

    def inspect
        super+@spot.inspect
    end
end

class MoveTransform
    def color
        COLORS[:sel]
    end
end

class CopyTransform
    def color
        COLORS[:copy]
    end
end

class SimplifyTransform
    def color
        COLORS[:simplify]
    end
end
