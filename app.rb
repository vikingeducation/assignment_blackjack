require 'sinatra'
require 'erb'
require 'pry-byebug'


get '/' do
  erb :home
end
