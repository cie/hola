Dir.chdir ".."
require "loader.rb"


Shoes.app :title=>"Hola" do
    extend SelectionGUI
    instance_eval &$setColors


    @win = stack

    def open eqn
        @expr = eqn.to_expr
        @win.clear do
            @expr.typeset self, @win, [MSelectableElement]
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


