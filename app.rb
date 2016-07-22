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
                            dealer_cards: dealer_cards.first, wording: nil }
end

post '/blackjack/hit' do
  session['player_cards'] << deal(session['deck'], 1)
  player_cards = session['player_cards']
  # player_cards = [[:ace,:spade],[:ace, :club],[10, :spade]]
  if bust?(player_cards)
    redirect('/blackjack/stay')
  else
    erb :blackjack, locals: {player_cards: session['player_cards'],
                             dealer_cards: session['dealer_cards'].first, wording: nil }
  end
end



# welcome -> form :player_name, creates a game instance, assigns the player name
get '/blackjack/stay' do

  dealer_cards = session['dealer_cards']
  while calc_value(dealer_cards) < 17 
    dealer_cards << deal[session['deck'], 1]
  end
  compare_cards(dealer_cards, session['player_cards'])

  #do stuff
  wording = "You lose"
  erb :blackjack, locals: {player_cards: session['player_cards'],
                             dealer_cards: session['dealer_cards'], wording: wording }

end
