require 'sinatra'
require "sinatra/reloader" if development?
require 'erb'
require 'pry-byebug'

enable :sesions

get '/' do
  erb :index
end