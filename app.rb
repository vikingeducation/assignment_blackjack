require 'sinatra'
require './helpers/handhelper.rb'
enable :sessions

helpers HandHelper

get '/' do
  redirect to 'blackjack'
end

get '/blackjack' do
  session[:deck] = [2, 3, 4, 5, 6, 7, 8, 9, 10, :J, :K, :Q, :A] * 4
  session[:deck].shuffle!
  session[:player_hand] = [session[:deck].pop]
  session[:player_hand] << session[:deck].pop
  session[:dealer_hand] = [session[:deck].pop]
  session[:dealer_hand] << session[:deck].pop
  redirect to '/blackjack/stay' if player_blackjack?
  redirect to 'blackjack/stay' if dealer_blackjack?
  erb :blackjack
end

get '/blackjack/hit' do
  session[:player_hand] << session[:deck].pop
  redirect to '/blackjack/stay' if player_bust?
  redirect to 'blackjack/stay' if player_blackjack?
  erb :blackjack
end

get '/blackjack/stay' do
  until value_of_hand(session[:dealer_hand]) >= 17
    session[:dealer_hand] << session[:deck].pop
  end
  erb :blackjack
  erb :result
end