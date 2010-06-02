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

class BinaryCommutativity < Transformation
    include SingleFeature
    def transform expr, sel, &block
        if sel.parent.is_a? eval(@exprclass)
            e = expr.deep_clone; e.path = []
            t = e[*sel.path]
            t.parent.swap
            t.parent.path = t.parent.path
            yield MoveTransform.new(e, t)
        end
    end
end

class RelationCompatibility < Transformation
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

class NaryCommutativity < Transformation
    include SingleFeature
    def transform expr, sel, &block
        if sel.parent.is_a? eval(@exprclass)
            Permutation.jumps(sel.path.last,sel.parent.size).each do |pm|
                expr2 = expr.deep_clone; expr2.path = [] 
                sel2 = expr2[*sel.path]
                sel2.parent.permute! pm
                sel2.parent.path = sel2.parent.path
                yield MoveTransform.new expr2, sel2
            end
        end
    end
end

class NaryTransposition < Transformation
    def initialize exprclass, &block
        @exprclass = exprclass
        @block = block
    end
    
    def transform expr, sel, &block
        par=sel.parent
        return if par.nil?
        grp=par.parent
        grpc = grp.class
        if par.is_a? eval(@exprclass)
            if grpc.features.include? RelationCompatibility.new(grpc.inspect, @exprclass)
                expr2 = expr.deep_clone; expr.path = []
                sel.path
                sel2 = expr2[*sel.path]
                par2 = sel2.parent
                grp2 = par2.parent
                p_other = par.path[-1] == :a ? :b : :a
                other2 = par2.instance_exec sel2, grp2[p_other], &@block
                grp2[p_other] = other2
                yield MoveTransform.new expr2, other2
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
            sel.parent.each do |s|
                if !s.equal? sel
                    expr.find s do |s2|
                        if !s.equal? s2
                            e = expr.deep_clone; e.path = [] 
                            t = e[*s2.path]
                            t2 = t.parent[s2.path.last] = s.deep_clone 
                            block[CopyTransform.new e, sel, t2]
                            p e, sel, t2, s2.path, :copied
                        end
                    end
                end
            end
        end
    end
end

