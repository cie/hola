=begin

MathML workalike for rendering maths equations in Shoes.

Rendering:
    e.getdim!
    e.setloc [0,0] *or* e.setlocdim [0,0], [w,h]
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
        @hit = app.flow opts do
            #app.border app.red, :strokewidth=>1
            @border = app.border COLORS[:sel], :strokewidth => 1
            @border.hide
        end
    end

    def opts 
        {:left => @loc[0], :top => @loc[1], :width=>@dim[0], :height=>@dim[1]}
    end

    def setloc newloc
        @loc = newloc
    end

    def defaultcolor
        :normal
    end

    def update
        hit.style opts
    end

    # hit area for mouse events
    def hit
        @hit
    end

    def select
        @border.show
    end

    def deselect
        @border.hide
    end

    def selcolor= color
        @border.style :stroke=>color
    end

end

class MContainer < MElement
    def render app
        @elems.each{|e|e.render app}
        # hit must be drawn after children's hit, to provide correct order in events:
        super 
    end

    def initialize
        @elems = []
    end
    attr_reader :elems

    def << elem
        @elems << elem
        self
    end

    def getdim!
        @elems.each { |x| x.getdim! }
    end

    def update
        super
        @elems.each {|e| e.update }
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

    def update
        super
        @para.style opts
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
        @lines = (1..@elems.count-1).map {app.line(0,0,0,0)}
        update
    end

    def update
        super
        @lines.each_with_index do |x,i|
            x.style(
                :left=>@loc[0] + @w*5/100,
                :top=> @loc[1] + @h*(i+1), 
                :right=> @loc[0] + @w*95/100, 
                :bottom=> @loc[1] + @h*(i+1),
                :stroke=>COLORS[:linecolor]
            )
        end
    end
end


class MFlow < MResizable
    def getdim!
        super
        @dim = [
            @elems.map{|e|e.dim[0]}.inject(0){|a,b|a+b},
            @elems.map{|e|e.dim[1]}.max,
        ]
    end
    def setlocdim newloc, newdim
        super
        minw = @elems.map{|e|e.dim[0]}.inject(0){|a,b|a+b}
        minh = @elems.map{|e|e.dim[1]}.max
        @w = [newdim[0], minw].max / @elems.size
        @h = [newdim[1], minh].max
        @elems.enum_with_index do |e,i|
            if e.is_a? MResizable
                e.setlocdim([
                            newloc[0] + @w*i,
                            newloc[1],
                ], [
                    @w, @h
                ])
            else 
                error("MFlows must contain MResizables.")
            end
        end
    end

    def render app
        super
        @lines = (1..@elems.count-1).map {app.line(0,0,0,0)}
        update
    end

    def update
        super
        @lines.each_with_index do |x,i|
            x.style(
                :left=>@loc[0] + @w*(i+1),
                :top=> @loc[1] + @h*5/100, 
                :right=> @loc[0] + @w*(i+1), 
                :bottom=> @loc[1] + @h*95/100,
                :stroke=>COLORS[:linecolor]
            )
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

