
module Vector
    def + other
        zip(other).map{|a,b|a+b}.extend Vector
    end
    def - other
        zip(other).map{|a,b|a-b}.extend Vector
    end
    def l2
        self[0]**2+self[1]**2
    end
    def / num
        map{|x|x/num.to_f}.extend Vector
    end
    def * num
        map{|x|x*num}.extend Vector
    end
end
