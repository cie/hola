require "utils/debug.rb"
require "gui/colors.rb"
require "expr/expr.rb"
require "parser/rdparser.rb"
require "parser/parser.rb"
require "profile/profile.rb"
require "typesetter/mathml.rb"
require "typesetter/typesetter.rb"
require "transform/paths.rb"
require "transform/manipulation.rb"
require "transform/transform.rb"
require "transform/permutation.rb"
require "transform/features.rb"
require "transform/vector.rb"
require "transform/transform_ui.rb"
require "gui/selection.rb"
require "gui/transformation.rb"
require "gui/app.rb"

concept_files = Dir.glob("concepts/**/*.rb")

concepts = concept_files.map do |x|
    require x
    x =~ /.*\/(.*)\.rb/
    eval($1.capitalize + "Expr")
end

$profile = Profile.new concepts, "profile/default.rb" 

