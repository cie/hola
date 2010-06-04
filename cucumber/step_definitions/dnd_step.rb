Dir.chdir(File.dirname(__FILE__) + "/../..")
require 'loader.rb'

W=600
H=400

Given /^az ablakban (.*) egyenlet van$/ do |a|
     @expr = a.to_expr
     c = []
     Typesetter.typesetcell @expr, c, [MSelectableElement]
     @m = c[0]
     @m.getdim!
     @m.setlocdim [0,0], [W,H]
end

When /^kijelölöm az? (.*)[öea]?-t$/ do |a|
    l = []
    @expr.find(a.to_expr){|x|l<<x}
    raise "Nincs ilyen alkifejezés: #{a}." if l.empty?
    x = l.first
    @sel = @m[*x.path]
    @transforms = @expr.transforms(x)
    @transforms.each do |tr|
        s = [0,0].extend(Vector)
        c = []
        Typesetter.typesetcell tr.display, c, []
        p tr.display
        m = c[0]
        m.getdim!
        m.setlocdim [0,0], [W,H]
        tr.targets.each do |t|
            p m
            mt = m[*t.path]
            s += mt.center
        end
        s /= tr.targets.size
        tr.instance_variable_set("@spot", s)
    end
end

When /^a kijelölt részt oda húzom, ahol most az? (.*) van$/ do |a|
    l = []
    @expr.find(a.to_expr){|x|l<<x}
    raise "Nincs ilyen alkifejezés: #{a}." if l.empty?
    x = l.first
    point = @m[*x.path].center
    @transform = @transforms.min{|a,b|
        (a.spot - point).l2 <=> (b.spot - point).l2}
end

Then /^(.*) lesz az egyenlet$/ do |a|
  @transform.result.should == a.to_expr
end

Then /^az? (.*) lesz kijelölve$/ do |a|
    @transform.selected.should == [a.to_expr]
end


When /^a kijelölt részt ([a-záéíóöőúüű]+) ([a-záéíóöőúüű]+) húzom attól, ahol most az? (.*) van$/ do |len,dir,a|
    v = case dir
        when "balra" then [-1,0]
        when "jobbra" then [1,0]
        when /f[eö]lfel[eé]/ then [0,-1]
        when /lefel[eé]/ then [0,1]
        end.extend Vector
    v *= case len
    when "kicsit" then 10
    when "valamivel" then 30
    when "jóval" then 50
    end
    l = []
    @expr.find(a.to_expr){|x|l<<x}
    raise "Nincs ilyen alkifejezés: #{a}." if l.empty?
    x = l.first
    point = @m[*x.path].center
    @transform = @transforms.min{|a,b|
        (a.spot - point + v).l2 <=> (b.spot - point + v).l2}
    
end


