require 'sinatra'
require "sinatra/reloader" if development?
require "./gamecore.rb"
require './helpers/bj_helper.rb'

helpers BlackJackHelper

enable :sessions

get "/" do
  # save_game([], [], true)
  session[:playercards] = []
  session[:dealercards] = []
  session[:gamestate] = true
  erb :home
end


get "/blackjack" do
  
  erb :game, :locals => {:dealercards => session[:dealercards], 
                         :playercards => session[:playercards], 
                         :gamestate => session[:gamestate]}

end

post "/blackjack" do
  game=Game.new(session[:dealercards], session[:playercards])

  # playercards=request.cookies["cards"["playercards"]]
  # dealercards=request.cookies["cards"["dealercards"]]
  choice = params[:choice]
  if choice == "Deal"
    game.deal
    if game.game_over?
      session[:gamestate] = true
     
      # erb :game, :locals => {:dealercards => game.dealercards, :playercards => game.playercards, :gamestate => session[:gamestate]}
       "<p>You win!</p>"
    else
      session[:gamestate] = false
      # erb :game, :locals => {:dealercards => game.dealercards, :playercards => game.playercards, :gamestate => session[:gamestate]}
    end

  elsif choice == "Hit"
    game.hit

    # response.set_cookie("cards",
    #           :playercards => game.playercards,
    #           :dealercards => game.dealercards, 
    #           :gamestate => gamestate)

    # redirect '/blackjack/hit'
  elsif choice == "Stand"
    game.stand
    # response.set_cookie("cards",
    #           :playercards => game.playercards,
    #           :dealercards => game.dealercards, 
    #           :gamestate => gamestate)
    # redirect '/blackjack/stay'
    
  end
  #Check for winner
  if game.game_over?
    gamestate = true

  else
    save_game(game.dealercards, game.playercards, gamestate)
    # response.set_cookie("cards",
    #           :playercards => game.playercards,
    #           :dealercards => game.dealercards, 
    #           :gamestate => gamestate)
  end

  erb :game, :locals => {:dealercards => game.dealercards, :playercards => game.playercards, :gamestate => session[:gamestate]}

#playercards, dealercards, winner = Game(playercards,dealercards)

end

# post '/blackjack/hit' do

#   erb :game, :locals => {:dealercards => session[:dealercards], 
#                          :playercards => session[:playercards], 
#                          :gamestate => session[:gamestate]}

# end

get '/blackjack/stay' do
  playercards=request.cookies["cards"["playercards"]]
  dealercards=request.cookies["cards"["dealercards"]]

  erb :stay, :locals => {:dealercards => dealercards, :playercards => playercards} 
end