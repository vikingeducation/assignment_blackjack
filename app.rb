#!/usr/bin/env ruby

require 'sinatra'
require 'thin'
require 'sinatra/reloader' if development?

enable :sessions

get '/' do
  erb :home
end

get '/blackjack' do
  erb :game
end

post '/blackjack/hit' do
  erb :game
end

post '/blackjack/stay' do
  erb :game
end

post '/blackjack/split' do
  erb :game
end

post '/blackjack/double' do
  erb :game
end
