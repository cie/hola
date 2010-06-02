module Permutation
    def self.jumps k, n
        (0..n-1).inject([]) do |l,i| 
            a = (0..n-1).to_a
            a.insert(i, a.delete_at(k))
            l + [a]
        end - [(0..n-1).to_a]
    end
end


class Array
    def permute pm
        (0..size-1).map{|x| self[pm[x]]}
    end
    def permute! pm
        replace permute(pm)
    end
end
