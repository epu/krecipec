$LOAD_PATH << File.dirname(__FILE__)
require 'app'
require 'sinatra/base'

run App.new
