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
            c = c.first
            c.getdim!
            c.setlocdim([0,0], [width, height])
            c.render self
        end
    end


    open ARGV[1] || "x-3!=10 && y-3==0"

end


