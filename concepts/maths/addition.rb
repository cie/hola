require 'expr/expr.rb'
require 'parser/parser.rb'

class AdditionExpr < AdditiveExpr
    self.plus = '+'
    self.minus = '-'
    self.priority = 30
    self.sign_priority = 80
end


