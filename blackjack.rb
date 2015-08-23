require 'sinatra'
require './helpers/helper.rb'

helpers BlackJackJudge

enable :sessions

get '/' do

  #session[:player] = session[:cards].sample(2)
  #session[:ai] = session[:cards].sample(2)
  session[:money] = 1000
  session[:status] = nil
  session[:cards] = ["A", 2, 3, 4, 5, 6, 7, 8, 9,10,"J","Q","K"]
  session[:chip] = nil

  erb :welcome

end

get '/bet' do

  #erb :bet, :locals => { :money => session[:money] } if session[:status] == nil
  session[:player] = session[:cards].sample(2)
  session[:ai] = session[:cards].sample(2)
  session[:chip] = nil
  if session[:status] == "no money"
    erb :poor
  else
    erb :bet, :locals => { :money => session[:money] }
  end

end

get '/blackjack' do
  session[:chip] = params[:choice].to_i if session[:chip] == nil
  result = ""
  if params[:action] == "hit" && check(session[:ai]) <= 16
      session[:player] << session[:cards].sample
      session[:ai] << session[:cards].sample
      result = bustcheck(session[:player])
      #if hit and owner is still getting cards
  elsif params[:action] == "hit" && check(session[:ai]) > 16
      session[:player] << session[:cards].sample
      result = bustcheck( session[:player])
      #if player's still getting card but owner stop
  elsif params[:action] == "stand" && check(session[:ai]) > 16
      result = wincheck( check(session[:ai]), check(session[:player]) )
  elsif params[:action] == "stand" && check(session[:ai]) <= 16
      session[:ai] << session[:cards].sample
  end
  session[:money] -= session[:chip] if result == "loss" || result == "bust"
  session[:money] += session[:chip] if result == "win"
  result = "poor" if session[:money] <= 0
  erb :bjack, :locals => {:player => session[:player], :result => result, :ai => session[:ai], :chip => session[:chip]}
end


