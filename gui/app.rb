
module GUI
    def self.app expr

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


            open expr

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
    end
end



