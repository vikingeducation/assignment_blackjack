require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry-byebug'

# root route
get '/' do
  erb :home
end
