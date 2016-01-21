require 'sinatra'
require 'thin'
require 'byebug'
require 'pp'
require 'json'
# require 'sinatra/reloader' if development?
require './helpers/blackjack'

enable :sessions

helpers do
  
  def set_session(game)
    session['player_deck'] = game.player_cards.to_json
    session['dealer_deck'] = game.dealer_cards.to_json
    session['main_deck'] = game.deck.to_json
    session['hit'] = game.hit
    session['loser'] = game.loser
    session['bet'] = game.bet
    session['totals'] = game.totals
  end

  def load_session
    player_deck = JSON.parse( session[:player_deck] )
    dealer_deck = JSON.parse( session[:dealer_deck] )
    deck = JSON.parse( session[:main_deck] )
    hit = session[:hit]
    loser = session[:loser]
    bet = session[:bet]
    totals = session[:totals]

    return player_deck,dealer_deck,deck,hit,loser,bet,totals
  end  
end


get '/' do
  game = Blackjack.new
  set_session(game)

  erb :index

end

post '/' do
  redirect to('/blackjack')
end

get '/blackjack' do
  load_session
  
  game = Blackjack.new

  player_deck,dealer_deck,deck,hit,loser,bet,totals = set_session(game)

  erb :blackjack, :locals => {:player_deck => player_deck, :dealer_deck => dealer_deck, :hit => hit, :loser => loser, :bet => bet, :totals => totals}
end

post '/blackjack' do
  load_session
  game = Blackjack.new(deck, player_deck, dealer_deck, hit, loser,bet,totals)
 
  player_deck,dealer_deck,deck,hit,loser,bet,totals = set_session(game)

  erb :blackjack, :locals => {:player_deck => player_deck, :dealer_deck => dealer_deck, :hit => hit, :loser => loser, :bet => bet, :totals => totals}

end

get '/blackjack/hit' do
  load_session
  game = Blackjack.new(deck, player_deck, dealer_deck, hit, loser,bet,totals)
  
  game.deal_card(player_deck)
  loser = game.who_lost

  set_session(game)
  
  erb :blackjack, :locals => {:player_deck => player_deck, :dealer_deck => dealer_deck, :hit => hit, :loser => loser, :bet => bet, :totals => totals}
end

get '/blackjack/stay' do

  load_session

  game = Blackjack.new(deck, player_deck, dealer_deck, hit, loser,bet,totals)
  
  game.dealer_play
  loser = game.who_lost

  set_session(game) 

  erb :blackjack, :locals => {:player_deck => player_deck, :dealer_deck => dealer_deck, :loser => loser, :hit => hit, :bet => bet, :totals => totals}

end

get '/blackjack/double' do

  load_session

  game = Blackjack.new(deck, player_deck, dealer_deck, hit, loser,bet,totals)
  
  game.double
  game.dealer_play
  loser = game.who_lost

  set_session(game)

  erb :blackjack, :locals => {:player_deck => player_deck, :dealer_deck => dealer_deck, :loser => loser, :hit => hit, :bet => bet, :totals => totals}

end