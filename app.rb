require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry-byebug'

get '/' do
  "Hello World!"
end
