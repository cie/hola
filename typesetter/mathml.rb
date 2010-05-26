=begin

MathML workalike for rendering maths equations in Shoes.

Rendering:
    e.getdim!
    e.setloc [0,0], [app.width, app.height]
    e.render app
=end

# Regex matching 1 UTF-8 character
# Used for estimating string widths by counting characters.
# taken from: http://www.w3.org/International/questions/qa-forms-utf-8 
UTF8REGEX = /[\x09\x0A\x0D\x20-\x7E] # ASCII 
                | [\xC2-\xDF][\x80-\xBF] # non-overlong 2-byte 
                | \xE0[\xA0-\xBF][\x80-\xBF] # excluding overlongs 
                | [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2} # straight 3-byte 
                | \xED[\x80-\x9F][\x80-\xBF] # excluding surrogates 
                | \xF0[\x90-\xBF][\x80-\xBF]{2} # planes 1-3 
                | [\xF1-\xF3][\x80-\xBF]{3} # planes 4-15 
                | \xF4[\x80-\x8F][\x80-\xBF]{2} # plane 16 
               /nx 

# Abstarct base class for MathML elements
class MElement
    attr_reader :dim
    attr_reader :loc
    attr_reader :fill
    attr_accessor :expr, :color

    # def getdim!

    def render app
        @app = app
    end

    def opts 
        p self, @loc, @dim
        {:left => @loc[0], :top => @loc[1], :width=>@dim[0], :height=>@dim[1]}
    end

    def setloc newloc
        @loc = newloc
    end

    def defaultcolor
        :normal
    end

end

class MContainer < MElement
    def render app
        super
        @elems.each{|e|e.render app}
    end

    def initialize
        @elems = []
    end

    def << elem
        @elems << elem
        self
    end

    def getdim!
        @elems.each { |x| x.getdim! }
    end

    
end

class MRow < MContainer
    SPACING = -3
    def getdim!
        super
        @dim = [
            @elems.map{|e|e.dim[0]}.inject{|a,b|a+b} + (@elems.size-1) * SPACING,
            @elems.map{|e|e.dim[1]}.max
        ]
    end

    def setloc newloc
        super
        x = 0
        @elems.each{|e| e.setloc([newloc[0] + x, newloc[1]]); x+=e.dim[0] + SPACING} 
    end
end

class MCol < MContainer
    SPACING = -3
    def getdim!
        super
        @dim = [
            @elems.map{|e|e.dim[0]}.max,
            @elems.map{|e|e.dim[1]}.inject{|a,b|a+b} + (@elems.size-1) * SPACING,
        ]
    end

    def setloc newloc
        super
        y = 0
        @elems.each{|e| e.setloc([newloc[0], newloc[1] + y]); y+=e.dim[0] + SPACING} 
    end
end

class MSimpleElement < MElement
    LETTER_W = 9
    LETTER_H = 30
    MARGIN = 8

    def initialize val
        @val = val
    end

    attr_accessor :val
    def color
        @color || COLORS[defaultcolor]
    end

    def color= color
        super
        @para.style(:stroke => color)
    end

    def render app
        super
        @para = app.para @val, opts.merge({:stroke => color})
    end

    def getdim!
        @dim = [@val.to_s.gsub(UTF8REGEX,'*').length * LETTER_W + MARGIN, LETTER_H] # counting chars utf8-safely
    end
end

class MI < MSimpleElement
    def defaultcolor 
        :id
    end
end

class MO < MSimpleElement
    def defaultcolor 
        :op
    end
end

class MN < MSimpleElement
    def defaultcolor 
        :num
    end
end

# Resizable containers

class MResizable < MContainer
    def setlocdim newloc, newdim
        setloc newloc
        @dim = newdim
    end
end


class MCell < MResizable
    def getdim!
        super
        @dim = @elems[0].dim
    end
    def setlocdim newloc, newdim
        super
        e = @elems[0]
        e.setloc([
                 newloc[0] + [0,(newdim[0]-e.dim[0])/2].max,
                 newloc[1] + [0,(newdim[1]-e.dim[1])/2].max,
        ])
    end
end

class MStack < MResizable
    def getdim!
        super
        @dim = [
            @elems.map{|e|e.dim[0]}.max,
            @elems.map{|e|e.dim[1]}.inject(0){|a,b|a+b}
        ]
    end
    def setlocdim newloc, newdim
        super
        minw = @elems.map{|e|e.dim[0]}.max
        minh = @elems.map{|e|e.dim[1]}.inject(0){|a,b|a+b}
        @w = [newdim[0], minw].max
        @h = [newdim[1], minh].max / @elems.size
        @elems.enum_with_index do |e,i|
            if e.is_a? MResizable
                e.setlocdim([
                            newloc[0],
                            newloc[1] + @h*i,
                ], [
                    @w, @h
                ])
            else 
                error("MStacks must contain MResizables.")
            end
        end
    end

    def render app
        super
        @lines = (1..@elems.count-1).map do |i|
            app.line @w*0.05, @h*i, @w*0.95, @h*i, :stroke=>COLORS[:linecolor]
        end
    end
end


=begin
class MStack < MCol
    def getdim!
        super
        @fill = [1, @elems.inject(0){|s,e|e.fill ? s+e.fill[1] : 1}]
    end

    def setloc newloc, newdim
        ybonus = [0,newdim[0]-@dim[0]].max / @fill[1] / 2
        y = 0
        @elems.each do |e| 
            e.setloc([
                     newloc[0] + (newdim[0] - e.dim[0])/2,
                     newloc[1] + ybonus
            ], [
                    newdim[0],
                    e.dim[1] + ybonus * 2
            ]) 
            y+=e.dim[0] + 2*ybonus
        end
    end
end
=end

