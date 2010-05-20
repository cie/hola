require "loader.rb"

tests = Dir.glob("tests/**/*_test.rb")

tests.each do |x|
    require x
end

