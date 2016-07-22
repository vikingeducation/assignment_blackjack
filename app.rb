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
  erb :blackjack, locals: { player_cards: player_cards,
                            dealer_cards: dealer_cards.first }
end

post '/blackjack/hit' do
  session['player_cards'] << deal(session['deck'], 1)
  player_cards = session['player_cards']
  if bust?(player_cards)
    redirect('/blackjack/stay')
  else
    erb :blackjack, locals: {player_cards: session['player_cards'],
                             dealer_cards: session['dealer_cards'].first }
  end
end



# welcome -> form :player_name, creates a game instance, assigns the player name
get '/blackjack/stay' do
  #do stuff

  erb :blackjack, locals: {player_cards: player_cards, dealer_cards: dealer_cards, message: message}

end
