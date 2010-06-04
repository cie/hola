class Expr

    class << self
        def features l=nil
            @features ||= []
            @features += l if l
            @features
        end
    end


    def transforms(sel)
        $profile.features.inject(
            [MoveTransform.new self.deep_clone!, sel] # no-op transform
        ) do |l, tn|
            tn.transform self, sel do |t|
                l << t
            end
            l
        end 
    end
end

class Feature
    def initialize exprclass
        @exprclass = exprclass
    end

    def == other
        instance_variables.map{|k|instance_variable_get(k) == other.instance_variable_get(k)}.all?
    end

    def transform expr, sel, &block
    end

end

module SingleFeature
    def initialize exprclass
        @exprclass = exprclass
    end
end
module RelativeFeature
    def initialize exprclass, otherclass
        @exprclass = exprclass
        @otherclass = otherclass
    end
end

class BinaryExpr
    def self.commutative
        BinaryCommutativity.new inspect
    end
    def self.symmetric
        BinaryCommutativity.new inspect
    end
    def self.compatible_with otherclass
        RelationCompatibility.new inspect, otherclass
    end
end

class BinaryCommutativity < Feature
    include SingleFeature
    def transform expr, sel, &block
        if sel.parent.is_a? eval(@exprclass)
            expr2 = expr.deep_clone!
            sel2 = expr2[*sel.path]
            sel2.parent.swap
            yield MoveTransform.new(expr2, sel2)
        end
    end
end

class RelationCompatibility < Feature
    include RelativeFeature
end


class NaryExpr
    def self.commutative
        NaryCommutativity.new inspect
    end
    def self.transpose &block
        NaryTransposition.new inspect, &block
    end
end

class NaryCommutativity < Feature
    include SingleFeature
    def transform expr, sel, &block
        if sel.parent.is_a? eval(@exprclass)
            Permutation.jumps(sel.path.last,sel.parent.size).each do |pm|
                expr2 = expr.deep_clone!
                sel2 = expr2[*sel.path]
                sel2.parent.permute! pm
                yield MoveTransform.new expr2, sel2
            end
        end
    end
end

class NaryTransposition < Feature
    def initialize exprclass, &block
        @exprclass = exprclass
        @block = block
    end
    
    def transform expr, sel, &block
        par = sel.parent
        return if par.nil?
        gpar = par.parent
        gparc = gpar.class
        if par.is_a? eval(@exprclass)
            if gparc.features.include? RelationCompatibility.new(gparc.inspect, @exprclass)
                expr2 = expr.deep_clone!
                sel2 = expr2[*sel.path]
                par2 = sel2.parent
                gpar2 = par2.parent
                pe_other = par.path.last == :a ? :b : :a
                target = par2.instance_exec sel2.path.last, gpar2[pe_other], &@block
                yield MoveTransform.new expr2, target
            end
        end
                
    end
end


class NullaryExpr
    def self.substitutes parent, grandparent
        Substitution.new inspect, parent, grandparent
    end
end

class Substitution
    def initialize exprclass, parent, grandparent
        @exprclass = exprclass
        @parent = parent
        @grandparent = grandparent
    end

    def transform expr, sel, &block
        if sel.parent.is_a? eval(@parent)
            sel.parent.each do |var|
                if !var.equal? sel
                    expr.find var do |place|
                        if !var.equal? place
                            expr2 = expr.deep_clone!
                            place2 = expr2[*place.path]
                            subs2 = sel.deep_clone
                            place2.parent[place.path.last] = subs2
                            block[CopyTransform.new(expr2, sel, t2)]
                            p expr2, sel, t2, place.path, :copied
                        end
                    end
                end
            end
        end
    end
end

