require 'sinatra'
require 'sinatra/reloader' if development?
require './lib/deck'

enable :sessions

get '/' do
  erb :home
end


get '/blackjack' do

  deck = session["deck_arr"] ? Deck.new(session["deck_arr"]): Deck.new

    #show player and dealer hands
  dealer_hand =


  erb :blackjack, locals: { deck: deck }
end


get '/blackjack/play' do
  erb :blackjack
end


#get the deck
#take one card from the deck
#add the card to the player's hand
post '/blackjack/hit' do
  card = Deck.new(session["deck_arr"]).deal
  


  erb :blackjack, loclas: {}
end