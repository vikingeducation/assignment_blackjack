require 'sinatra'
require 'pry-byebug'
require 'erb'
require './helpers/blackjack_helper.rb'

helpers BlackjackHelper
enable :sessions

get '/' do
  redirect to('blackjack')
end

get '/blackjack' do
  session[:deck] = [2,3,4,5,6,7,8,9,10,:J,:Q,:K,:A] * 4
  session[:deck].shuffle!
  session[:hole_card] = session[:deck].pop
  session[:player_hand] = [session[:deck].pop]
  session[:dealer_upcards] = [session[:deck].pop]
  session[:player_hand] << session[:deck].pop
  erb :blackjack
end

get '/blackjack/hit' do
  session[:player_hand] << session[:deck].pop
  if value(session[:player_hand]) > 21
    redirect to 'blackjack/stay'
  end
  erb :blackjack
end

get '/blackjack/stay' do
  "BUSTED!"
end