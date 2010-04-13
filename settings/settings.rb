require 'parser/rdparser.rb'
require 'parser/parser.rb'

exprs = %w{ addition equation integer parenthesis variable }
exprclasses = []

exprs.each do |x|
    require "maths/#{x}.rb"
    exprclasses << eval(x.capitalize + 'Expr') 
end

$parser = Parser.new *exprclasses

