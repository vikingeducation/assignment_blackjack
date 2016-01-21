#!/usr/bin/env ruby

require 'sinatra'
require 'thin'
require 'pry-byebug'
require 'sinatra/reloader' if development?

also_reload 'lib/*'

enable :sessions

get '/' do
  erb :home
end

get '/blackjack' do
  @test = session[:status]
  erb :game
end

post '/blackjack/hit' do
  session[:status] = "hit"
  session[:player_cards] = ['AS','JC']

  redirect '/blackjack'
end

post '/blackjack/stay' do
  session[:status] = "stay"
  redirect '/blackjack'
end

post '/blackjack/split' do
  redirect '/blackjack'
end

post '/blackjack/double' do
  redirect '/blackjack'
end
