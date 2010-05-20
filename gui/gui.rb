Dir.chdir ".."
require "loader.rb"

Shoes.app :title=>"Hola" do
    
    @win = stack


    def open eqn
        @win.clear do
            e = MX.new(eqn.to_expr)
            e.getdim!
            e.loc=[0,0]
            e.render self
        end
    end


    if ARGV.length > 1
        open ARGV[1]
    else
        open "x-3!=10"
    end

    
end
