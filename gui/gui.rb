Dir.chdir ".."
require "loader.rb"


Shoes.app :title=>"Hola" do
    extend Selection
    instance_eval &$setColors


    @win = stack

    def open eqn
        @win.clear do
            c = []
            Typesetter.typesetcell eqn.to_expr, c, [MSelectableElement]
            @m = c.first
            @m.getdim!
            @m.setlocdim([0,0], [width, height])
            @m.render self
        end
    end


    open ARGV[1] || "x-3!=10 && y-3==0"

    @dim = [width, height]
    animate 1 do
        if @dim != [width, height]
            if @m
                @m.getdim!
                @m.setlocdim([0,0], [width, height])
                @m.update
            end
            @dim = [width, height]
        end 
    end


end


