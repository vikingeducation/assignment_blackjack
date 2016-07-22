require 'sinatra'
require 'pry-byebug'
require 'sinatra/reloader' if development?
require './helpers/blackjack_helper.rb'

enable :sessions

helpers BlackjackHelper

get '/' do
  erb :welcome
end

get '/blackjack' do
  turn = session['turn'] = 'player'
  deck = session['deck'] = new_deck.shuffle
  player_cards = session['player_cards'] = deal(deck, 2)
  dealer_cards = session['dealer_cards'] = deal(deck, 2)
  erb :blackjack, locals: { deck: deck, player_cards: player_cards,
                            dealer_cards: dealer_cards }
end



# welcome -> form :player_name, creates a game instance, assigns the player name
