require 'sinatra'
require 'pry-byebug'
require 'erb'

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