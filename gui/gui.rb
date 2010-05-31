# entry point of the application
Dir.chdir ".."
require "loader.rb"


Shoes.app :title=>"Hola" do
    extend SelectionGUI
    extend TransformationGUI
    instance_eval &$setColors


    @win = stack

    def open expr
        @expr = expr
        @win.clear do
            @m = expr.typeset self, [width, height], [MSelectableElement]
        end
        @sels = []
    end


    open (ARGV[1] || "x-a!=10 && y-3==0 && y+4+5+4+4=3").to_expr

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


