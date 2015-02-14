require 'sinatra'
require 'json'
require './helpers/schwaddyhelper.rb'

helpers Schwaddyhelper

enable :sessions

#put all needed methods in schwaddyhelper module
# #DON'T GOOF AROUND W CLASSES SCHWAD


  



#   def hit
    # @hit = @my_current_deck.flatten.sample(1)
    # @my_current_deck = @my_current_deck - @hit
#     return @hit
#   end


get '/' do
  session[:original_deck] =  (["2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"].product(["2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"])).to_json
  session[:current_deck] = []
  session[:deal] = []
  session[:hit] = []
  session[:counter] = 1
  session[:feedback] = "Things.... are gonna get real."
  session[:dealer_feedback] = "Lets see how it shakes out"
  session[:dealer_show] = ""
  erb :home
end

get '/blackjack' do
  #move to module

  lets_deal
  @dealer_hand = JSON.parse(session[:dealer_hand])
  @player_hand = JSON.parse(session[:player_hand])
  @my_current_deck = JSON.parse(session[:original_deck]) - @deal[0]
  erb :blackjack

end

post '/blackjack/hit' do
  @dealer_hand = JSON.parse(session[:dealer_hand])
  @player_hand = JSON.parse(session[:player_hand])
  @shuffle_up = JSON.parse(session[:shuffle_up])
  @count = session[:counter]
  @player_hand << @shuffle_up.flatten[@count]
  session[:shuffle_up] = @shuffle_up.to_json
  "Player hits! You got #{@player_hand[-1]} "
  "Current hand: #{@player_hand} "
  session[:player_score] = adder(@player_hand)
  session[:counter] = @count + 1
  session[:player_hand] = @player_hand.to_json
  if adder(@player_hand) > 21 && @player_hand.include?("Ace")
    results = adder(@player_hand) - 10
    session[:feedback] = "Your current score is #{results}"
  elsif adder(@player_hand) > 21
    session[:feedback] = "You lose! You got #{adder(@player_hand)}"
  elsif adder(@player_hand) < 21
    session[:feedback] = "Your current score is #{adder(@player_hand)}. Hit or stay?"
  elsif adder(@player_hand) == 21
    session[:feedback] = "Your score is #{adder(@player_hand)}, sweet!"
  end
  erb :blackjack
end

post '/blackjack/stay' do
  @dealer_hand = JSON.parse(session[:dealer_hand])
  @player_hand = JSON.parse(session[:player_hand])
  @shuffle_up = JSON.parse(session[:shuffle_up])
  @count = session[:counter] + 1
  @player_score = session[:player_score]
  until adder(@dealer_hand) >= 17
    @dealer_hand << @shuffle_up.flatten[@count]
    @count += 1
  end
  if adder(@dealer_hand) > 21
    session[:dealer_feedback] = "Dealer score is #{adder(@dealer_hand)}, dealer busts!"
  elsif adder(@dealer_hand) > @player_score
    session[:dealer_feedback] = "Dealer score is #{adder(@dealer_hand)}, dealer wins!"
  elsif adder(@dealer_hand) == @player_score
    session[:dealer_feedback] = "Dealer score is #{adder(@dealer_hand)}, draw!"
  else
    session[:dealer_feedback] = "Player wins!"
  end
  session[:dealer_show] = @dealer_hand
  
  erb :blackjack
end

# get '/bet'

# end

# post '/bet'

# end
