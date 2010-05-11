Dir.chdir ".."
require "loader.rb"

Shoes.app :title=>"Hola" do
    
    @win = stack


    def open eqn
        @win.clear do
            eqn.to_expr.typeset self
        end
    end


    if ARGV.length > 1
        open ARGV[1]
    else
        open "x-3!=10"
    end

    
end
