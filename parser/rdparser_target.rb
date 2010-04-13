parser = RDParser.new do
   token(/\s+/)
   token(/\d+/) {|m| m.to_i }
   token(/./) {|m| m }

   start :expr do
     match(:expr, '+', :term) {|a, _, b| a + b }
     match(:expr, '-', :term) {|a, _, b| a - b }
     match(:term)
   end

   rule :term do
     match(:term, '*', :dice) {|a, _, b| a * b }
     match(:term, '/', :dice) {|a, _, b| a / b }
     match(:dice)
   end
