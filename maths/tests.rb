exprs = %w{ addition equation integer parenthesis variable }
exprs.each do |x|
    require "maths/#{x}_test.rb"
end

