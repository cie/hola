require "expr/expr.rb"
require "parser/parser.rb"
require "profile/profile.rb"
#require "transform/

concepts = Dir.glob("concepts/**/*.rb")
tests = Dir.glob("**/*_test.rb")

expr_classes = []
(concepts-tests).each do |x|
    p x
    require x
    x =~ /.*\/(.*)\.rb/
    expr_classes << eval($1.capitalize + "Expr")
end

$profile = Profile.new expr_classes, []

