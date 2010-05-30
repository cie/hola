require 'set'
$my_methods={}
$classes = []

class Class
    def my_methods
        $my_methods[self] || []
    end

    def method_added m
        $my_methods[self] ||= []
        $my_methods[self] << m
    end


    def inherited c
        $classes << c
    end
end

module LovelyClass
    def new *args, &block
        super.extend $modules[self]
    end
end

module Lovely
    class << self
        def start 
            $methods = Set.new
            $good_methods = Set.new
            $modules = {}
            cs = $classes
            $classes= []
            cs.each do |c|
                c.extend LovelyClass
                c.my_methods.each do |m|
                    $methods << [c,m]
                end
                $modules[c]=Module.new
                c.my_methods.each do |m|
                    if true
                        $modules[c].class_eval <<EOT
                            def #{m} *args, &block
                                #p [self, :#{m}, args, block]
                                $good_methods << [self.class,:#{m}]
                                super
                            end
EOT
                    end
                end
            end
        end

        def add *objs
            objs.each do |o|
                o.extend $modules[o.class]
            end
        end

        def finish
            ($methods-$good_methods)
        end

        def print
            puts "Methods not tested:"
            if Lovely::finish
                Lovely::finish.map do |x|
                    "#{x[0]}##{x[1]}"
                end.sort.each {|x| puts x}
            else
                puts "None."
            end
            Lovely::finish
        end
    end
end



