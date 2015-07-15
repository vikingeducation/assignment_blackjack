require 'sinatra'
require "sinatra/reloader" if development?


get "/blackjack" do

"<h1>Play Blackjack</h1>
  <form action='/game' method='post'>
    <input type='submit' value='Play'>
  </form>"
  response.set_cookie("cards",
            :playercards => [],
            :dealercards => [])

end


get "/game" do
response.set_cookie("cards",
            :playercards => playercards,
            :dealercards => dealercards)

playercards, dealercards, winner = Game(playercards,dealercards)

erb :game, :locals => {:dealercards => dealercards, :playercards => playercards}
choice = params[:choice]


end