# app.rb
require 'sinatra'
require 'erb'

get '/' do
 erb :home
end
