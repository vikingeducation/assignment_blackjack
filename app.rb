#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader' if development?
require './lib/blackjack.rb'
require './helpers/saver.rb'
require 'pry-byebug'

# dealer and player are each dealt 2 cards
# player can see their two cards, but only the 2nd card for the dealer
# session stores: bet amount, how much money they have, their hand, dealer's hand, deck



helpers Saver


enable :sessions


get '/' do
  erb :index
end

get '/new' do
  bankroll = params[:bankroll]
  blackjack = Blackjack.new(session[:deck])
  dealer, player = blackjack.start_game
  shoe = blackjack.get_shoe

  save_dealer(dealer)
  save_player(player)
  save_deck(shoe)
  save_bankroll(bankroll)

  erb :blackjack, :locals => { :dealer => dealer, :player => player, :deck => shoe, :bankroll => session[:bankroll]}
end

get '/blackjack' do
  erb :blackjack, locals: { dealer: session[:dealer], player: session[:player], deck: session[:deck], bankroll: session[:bankroll]}
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



post '/new' do


end


post '/blackjack/hit' do
  blackjack = Blackjack.new(load_deck)

  session[:bet] = params[:bet] unless session[:bet]

  session[:player] = blackjack.hit(session[:player])

  save_deck(blackjack.get_shoe)

  if blackjack.bust?(session[:player])
    session[:bankroll] = (session[:bankroll].to_i - session[:bet].to_i).to_s
    redirect('/loss')
  else
    redirect('/blackjack')
  end

end

post '/blackjack/stay' do
  blackjack = Blackjack.new(load_deck)
  session[:dealer] = blackjack.dealer_hit(session[:dealer])

  session[:bet] = params[:bet] unless session[:bet]

  save_deck(blackjack.get_shoe)

  if blackjack.bust?(session[:dealer])
    redirect('/win')
  else
    outcome = blackjack.outcome(session[:dealer], session[:player])
    redirect("/#{outcome}")
  end
end

post '/blackjack/split' do

end