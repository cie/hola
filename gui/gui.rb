# entry point of the application
Dir.chdir ".."
require "loader.rb"

GUI::app( (ARGV[1] || "a+b=3 && (3+a)+(b+b)=7").to_expr)

