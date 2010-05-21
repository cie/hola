=begin
Rendering:
    e.getdim!
    e.loc=[0,0]
    e.render app
=end

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

class MElement
    attr_reader :dim
    attr_accessor :loc

    def getdim!
        @dim = [0,0]
    end

    def opts 
        {:left => @loc[0], :top => @loc[1], :width=>@dim[0], :height=>@dim[1]}
    end

    def render ; end
end

class MContainer < MElement
    def initialize
        @elems = []
    end

    def << elem
        @elems << elem
    end

    def getdim!
        @elems.each { |x| x.getdim! }
    end
    
end

class MRow < MContainer
    SPACING = -3
    def render app
        @elems.each{|e|e.render app}
    end

    def getdim!
        super
        @dim = [
            @elems.map{|e|e.dim[0]}.inject{|a,b|a+b} + (@elems.size-1) * SPACING,
            @elems.map{|e|e.dim[1]}.max
        ]
    end

    def loc= newloc
        super
        x = 0
        @elems.each{|e| e.loc=[newloc[0] + x, newloc[1]]; x+=e.dim[0] + SPACING} 
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
        @color = color
        @para.style(:stroke => color)
    end

    def render app
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

