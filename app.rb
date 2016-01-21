require 'sinatra'
require "sinatra/reloader" if development?

require './blackjack.rb'

get '/' do
  erb :index
end

get '/blackjack' do
  erb :blackjack
end
