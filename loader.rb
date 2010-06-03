require "utils/debug.rb"
require "gui/colors.rb"
require "expr/expr.rb"
require "parser/grammar.rb"
require "utils/rdparser.rb"
require "parser/parser.rb"
require "profile/profile.rb"
require "typesetter/mathml.rb"
require "typesetter/typesetter.rb"
require "transform/paths.rb"
require "transform/manipulation.rb"
require "transform/transform.rb"
require "utils/permutation.rb"
require "transform/features.rb"
require "transform/transform_ui.rb"
require "gui/selection.rb"
require "gui/transformation.rb"
require "gui/app.rb"

concepts = Dir.glob("concepts/**/*.rb")
tests = Dir.glob("**/*_test.rb")

expr_classes = []
(concepts-tests).each do |x|
    require x
    x =~ /.*\/(.*)\.rb/
    expr_classes << eval($1.capitalize + "Expr")
end

$profile = Profile.new expr_classes
File.open "profile/default.rb" do |f| 
    $profile.instance_eval f.read 
end

