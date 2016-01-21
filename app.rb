require 'sinatra'
require 'thin'
require 'byebug'
require 'pp'
require 'json'
# require 'sinatra/reloader' if development?
require './helpers/blackjack'

enable :sessions

get '/' do
  game = Blackjack.new
  session['player_deck'] = game.player_cards.to_json
  session['dealer_deck'] = game.dealer_cards.to_json
  session['main_deck'] = game.deck.to_json
  session['hit'] = game.hit
  session['loser'] = game.loser

  erb :index

end

post '/' do
  redirect to('/blackjack')
end

get '/blackjack' do
  game = Blackjack.new
  player_deck = JSON.parse( session[:player_deck] )
  dealer_deck = JSON.parse( session[:dealer_deck] )
  deck = JSON.parse( session[:main_deck] )
  hit = session[:hit]
  loser = session[:loser]

  erb :blackjack, :locals => {:player_deck => player_deck, :dealer_deck => dealer_deck, :hit => hit, :loser => loser}
end

post '/blackjack' do
  player_deck = JSON.parse( session[:player_deck] )
  dealer_deck = JSON.parse( session[:dealer_deck] )
  deck = JSON.parse( session[:main_deck] )
  hit = session[:hit]
  loser = session[:loser]
  
  game = Blackjack.new(deck, player_deck, dealer_deck, hit, loser)
  
  session['player_deck'] = game.player_cards.to_json
  session['dealer_deck'] = game.dealer_cards.to_json
  session['main_deck'] = game.deck.to_json
  session['hit'] = hit
  session['loser'] = loser

  erb :blackjack, :locals => {:player_deck => player_deck, :dealer_deck => dealer_deck, :hit => hit, :loser => loser}

end

get '/blackjack/hit' do

  player_deck = JSON.parse( session[:player_deck] )
  dealer_deck = JSON.parse( session[:dealer_deck] )
  deck = JSON.parse( session[:main_deck] )
  hit = session[:hit]
  loser = session[:loser]

  game = Blackjack.new(deck, player_deck, dealer_deck, hit, loser)
  
  game.deal_card(player_deck)
  loser = game.who_lost

  session['player_deck'] = game.player_cards.to_json
  session['main_deck'] = game.deck.to_json
  session['hit'] = hit
  session['loser'] = loser
  
  erb :blackjack, :locals => {:player_deck => player_deck, :dealer_deck => dealer_deck, :hit => hit, :loser => loser}
end

get '/blackjack/stay' do

  player_deck = JSON.parse( session[:player_deck] )
  dealer_deck = JSON.parse( session[:dealer_deck] )
  deck = JSON.parse( session[:main_deck] )
  hit = false
  loser = session[:loser]

  game = Blackjack.new(deck, player_deck, dealer_deck, hit, loser)
  
  game.dealer_play
  loser = game.who_lost

  session['dealer_deck'] = game.dealer_cards.to_json
  session['main_deck'] = game.deck.to_json
  session['hit'] = hit
  session['loser'] = loser

  erb :blackjack, :locals => {:player_deck => player_deck, :dealer_deck => dealer_deck, :loser => loser, :hit => hit}

end
