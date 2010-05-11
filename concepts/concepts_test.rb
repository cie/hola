require "loader.rb"

tests = Dir.glob("concepts/**/*_test.rb")

tests.each do |x|
    require x
end

