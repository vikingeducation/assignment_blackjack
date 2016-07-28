require 'sinatra'
require 'erb'
require 'pry-byebug'
require './helpers/deck_helpers.rb'
helpers DeckHelper
enable :sessions

get '/' do
  erb :home
end

get '/blackjack' do
  create_deck
  erb :blackjack
end
