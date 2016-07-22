require 'sinatra'
require 'sinatra/reloader' if development?
require './lib/deck'
require 'json'

enable :sessions

get '/' do
  erb :home
end


get '/blackjack' do

  deck = session["deck_arr"] ? load_deck : Deck.new

    #show player and dealer hands
    if  session["player_hand_arr"] 
      player_hand = Player.new(JSON.parse(session["player_hand_arr"])).hand
    else
      player_hand = Player.new.hand
      sesion["player_hand_arr"] = player_hand
    end


  erb :blackjack, locals: { deck: deck }
end


get '/blackjack/play' do
  erb :blackjack
end


#get the deck
#take one card from the deck
#add the card to the player's hand
post '/blackjack/hit' do
  deck = Deck.new(session["deck_arr"])
  card = deck.deal
  session["deck_arr"] = deck.deck_arr.to_json
  



  erb :blackjack, locals: {}
end