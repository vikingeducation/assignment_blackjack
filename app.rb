#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader' if development?
require './lib/blackjack.rb'
require './helpers/saver.rb'
require 'pry-byebug'
require './helpers/bankroll.rb'


helpers Saver, Bankroll


enable :sessions


get '/' do
  # is this necessary?
  session.each do |key, value|
    session[key] = nil
  end
  erb :index
end

get '/new' do
  session[:bankroll] = params[:bankroll] if session[:bankroll].nil?

  erb :bet, locals: { bankroll: session[:bankroll], bet: session[:bet] }
end

post '/start' do
  session[:bet] = params[:bet]
  unless valid_bet?(session[:bankroll], session[:bet])
    redirect('/new')
  end


  blackjack = Blackjack.new(session[:deck])
  dealer, player = blackjack.start_game
  session[:outcome] = blackjack.check_blackjack(dealer, player)
  unless session[:outcome].nil?
    redirect('/new')
  end
  
  shoe = blackjack.get_shoe

  save_dealer(dealer)
  save_player(player)
  save_deck(shoe)

  erb :blackjack, :locals => { :dealer => dealer, :player => player, :deck => shoe, :bankroll => session[:bankroll], bet: session[:bet], outcome: session[:outcome]}
end

get '/blackjack' do
  erb :blackjack, locals: { dealer: session[:dealer], player: session[:player], deck: session[:deck], bankroll: session[:bankroll], bet: session[:bet], outcome: session[:outcome]}
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
  redirect("/blackjack")
end