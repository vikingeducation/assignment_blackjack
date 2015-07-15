require 'sinatra'
require "sinatra/reloader" if development?
require "./gamecore.rb"

get "/" do


  response.set_cookie("cards",
            :playercards => [],
            :dealercards => [], 
            )
  erb :home
end


get "/blackjack" do
  playercards=request.cookies["cards"["playercards"]]
  dealercards=request.cookies["cards"["dealercards"]]
  gamestate=true #request.cookies["cards"["gamestate"]]
  
  erb :game, :locals => {:dealercards => dealercards, :playercards => playercards, :gamestate => gamestate}

  
end

post "/blackjack" do
  game=Game.new(playercards,dealercards)

  playercards=request.cookies["cards"["playercards"]]
  dealercards=request.cookies["cards"["dealercards"]]
  choice = params[:choice]
  if choice == "Deal"
    
    if game.game_over?
      gamestate = true
     
      erb :game, :locals => {:dealercards => dealercards, :playercards => playercards}
       "<p>You win!</p>"
    else
      gamestate = false
    end

  elsif choice == "Hit"
    game.hit

    response.set_cookie("cards",
              :playercards => game.playercards,
              :dealercards => game.dealercards, 
              :gamestate => gamestate)

    redirect '/blackjack/hit'
  elsif choice == "Stand"
    game.stand
    response.set_cookie("cards",
              :playercards => game.playercards,
              :dealercards => game.dealercards, 
              :gamestate => gamestate)
    redirect '/blackjack/stay'
    
  end
  #Check for winner
  if game.game_over?
    gamestate = true

  else
    response.set_cookie("cards",
              :playercards => game.playercards,
              :dealercards => game.dealercards, 
              :gamestate => gamestate)
  end

#playercards, dealercards, winner = Game(playercards,dealercards)

end

get '/blackjack/hit' do
  playercards=request.cookies["cards"["playercards"]]
  dealercards=request.cookies["cards"["dealercards"]]

  erb :hit, :locals => {:dealercards => dealercards, :playercards => playercards} 
end

get '/blackjack/stay' do
  playercards=request.cookies["cards"["playercards"]]
  dealercards=request.cookies["cards"["dealercards"]]

  erb :stay, :locals => {:dealercards => dealercards, :playercards => playercards} 
end