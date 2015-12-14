require 'sinatra'
require 'erb'
require 'pry'

get '/' do
  erb :index
end