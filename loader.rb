concepts = Dir.glob("concepts/**/*.rb")
tests = Dir.glob("**/*_test.rb")

(concepts-tests).each do |x|
    require x
end

$profile = Profile.new

