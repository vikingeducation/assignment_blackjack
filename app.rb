#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader' if development?
require './lib/blackjack.rb'
require './helpers/saver.rb'
require 'pry-byebug'
require './helpers/bankroll.rb'

# dealer and player are each dealt 2 cards
# player can see their two cards, but only the 2nd card for the dealer
# session stores: bet amount, how much money they have, their hand, dealer's hand, deck



helpers Saver, Bankroll


enable :sessions


get '/' do
  session.each do |key, value|
    session[key] = nil
  end
  erb :index
end

get '/new' do
  bankroll = params[:bankroll]
  save_bankroll(bankroll)

  erb :bet, locals: { bankroll: session[:bankroll] }
end

post '/start' do
  session[:bet] = params[:bet]
  unless check_bet?(session[:bankroll], session[:bet])
    erb :bet, locals: { bankroll: session[:bankroll] }
  end

  blackjack = Blackjack.new(session[:deck])
  dealer, player = blackjack.start_game
  session[:outcome] = blackjack.check_blackjack(dealer, player)
  
  
  shoe = blackjack.get_shoe

  save_dealer(dealer)
  save_player(player)
  save_deck(shoe)

  erb :blackjack, :locals => { :dealer => dealer, :player => player, :deck => shoe, :bankroll => session[:bankroll], bet: session[:bet], outcome: session[:outcome]}
end

get '/blackjack' do
  erb :blackjack, locals: { dealer: session[:dealer], player: session[:player], deck: session[:deck], bankroll: session[:bankroll], bet: session[:bet], outcome: session[:outcome]}
end


get '/loss' do
  erb :loss, locals: { dealer: session[:dealer], player: session[:player], bankroll: session[:bankroll] }
end

get '/win' do
  erb :win, locals: { dealer: session[:dealer], player: session[:player], bankroll: session[:bankroll]}
end

get '/tie' do
  erb :tie, locals: { dealer: session[:dealer], player: session[:player]}
end

post '/blackjack/hit' do
  blackjack = Blackjack.new(load_deck)

  session[:player] = blackjack.hit(session[:player])

  save_deck(blackjack.get_shoe)

  if blackjack.bust?(session[:player])
    update_bankroll('loss')
  end
  redirect('/blackjack')
end

post '/blackjack/stay' do
  blackjack = Blackjack.new(load_deck)
  session[:dealer] = blackjack.dealer_hit(session[:dealer])

  save_deck(blackjack.get_shoe)

  if blackjack.bust?(session[:dealer])
    update_bankroll('win')
  else
    outcome = blackjack.outcome(session[:dealer], session[:player])
    update_bankroll(outcome)
  end
  if outcome.nil?
    redirect("/blackjack")
  else
    redirect("/new")
  end
end