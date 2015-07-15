require 'sinatra'
require "sinatra/reloader" if development?
require "./gamecore.rb"
require './helpers/bj_helper.rb'

helpers BlackJackHelper

enable :sessions

get "/" do

  session[:playercards] = []
  session[:dealercards] = []
  session[:bankroll] = 1000
  session[:gamestate] = true
  erb :home
end

get "/bet" do
  session[:bankroll]-=params[:bet]
  erb :bet
end


get "/blackjack" do
  
  
  erb :game , :locals => {:dealercards => session[:dealercards], 
                         :playercards => session[:playercards], 
                         :gamestate => session[:gamestate],
                         :bankroll => session[:bankroll]
                       }

end

post "/blackjack" do
  
  if session[:gamestate] == true
  session[:dealercards] = []
  session[:playercards] = []
  session[:bankroll] = 1000
  end

game=Game.new(session[:dealercards], session[:playercards])
  choice = params[:choice]
  if choice == "Deal"
    game.deal
    if game.game_over(choice)
      session[:gamestate] = true
    else
      session[:gamestate] = false
    end

  elsif choice == "Hit"
    game.hit
  elsif choice == "Stand"
    game.stand
  end

  #Check for winner
  if game.game_over(choice)
    session[:gamestate] = true

    session[:message] = game.game_over(choice)
    redirect '/blackjack/stay'
  else
    save_game(game.dealercards, game.playercards, session[:gamestate])  
  end

  erb :game, :locals => {:dealercards => game.dealercards, :playercards => game.playercards, :gamestate => session[:gamestate], :bankroll => session[:bankroll]}

#playercards, dealercards, winner = Game(playercards,dealercards)

end

# post '/blackjack/hit' do

#   erb :game, :locals => {:dealercards => session[:dealercards], 
#                          :playercards => session[:playercards], 
#                          :gamestate => session[:gamestate]}

# end

get '/blackjack/stay' do


  erb :stay, :locals => {:dealercards => session[:dealercards], :playercards => session[:playercards], :message => session[:message]} 

end