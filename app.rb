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
  erb :bet, :locals => {:bankroll => session[:bankroll], 
                        :message => session[:not_enough_money]}
end

post "/bet" do
  session[:not_enough_money] = nil
  erb :bet, :locals => {:bankroll => session[:bankroll], 
                        :message => session[:not_enough_money]}
end

get "/blackjack" do

  session[:bet] = params[:bet].to_i
  session[:bankroll]-=params[:bet].to_i
  erb :game , :locals => {:dealercards => session[:dealercards], 
                         :playercards => session[:playercards], 
                         :gamestate => session[:gamestate],
                         :bankroll => session[:bankroll],:bet => session[:bet]
                       }

end

post "/blackjack" do
  if params[:bet].to_i > session[:bankroll]
    session[:not_enough_money] = "You don't have enough money"
    redirect "/bet"
  else
 
  
    if session[:gamestate] == true
    session[:dealercards] = []
    session[:playercards] = []
    #session[:bet] = 0
    # session[:bankroll] = 1000
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
      session[:message] = game.game_over(choice)
      case session[:message]
      when "Winner!"
        session[:bankroll] += 2*session[:bet]
      when "Tie!"

        session[:bankroll] += session[:bet]
      end
      session[:gamestate] = true
      redirect '/blackjack/stay'
    else
      save_game(game.dealercards, game.playercards, session[:gamestate])  
    end
  end

  erb :game, :locals => {:dealercards => game.dealercards, :playercards => game.playercards, :gamestate => session[:gamestate], :bankroll => session[:bankroll], :bet => session[:bet]}


get '/blackjack/stay' do


  erb :stay, :locals => {:dealercards => session[:dealercards], :playercards => session[:playercards], :message => session[:message]} 

end

get "/not_enough_money" do
  erb :not_enough_money
end