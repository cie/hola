Dir.chdir '..'
#require 'loader.rb'
require 'rubygems'

version = ">= 0"
gem 'cucumber'
load Gem.bin_path('cucumber', 'cucumber', version)
