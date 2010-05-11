class Expr
    def self.typesetter &block # { |app| app.flow { @a.typeset app; app.para @op; @b.typeset app } }
        @typesetter = block if not block.nil?
        @typesetter || (superclass != Expr ? superclass.typesetter : lambda {|x| error("Unimplemented typesetter")})
    end


    def typeset app
        app.flow do
            instance_exec app, &self.class.typesetter
        end
    end

end


