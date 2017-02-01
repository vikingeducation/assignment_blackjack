require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'pry'

enable :sessions

get '/' do
  erb :index
end

get '/blackjack' do
  deck = session['deck'] ? JSON.parse(session['deck']) :  %w{1 2 3 4 5 6 7 8 9 10 jack queen king ace}.product(%w{diamonds clubs hearts spades}).shuffle
  # deal hands
  if session['deck']
    player = JSON.parse(session['player'])
    dealer = JSON.parse(session['dealer'])
    deck = JSON.parse(session['deck'])
  else
    player, dealer = [], []
    deck = %w{1 2 3 4 5 6 7 8 9 10 jack queen king ace}.product(%w{diamonds clubs hearts spades}).shuffle
    2.times do
      s = deck.sample
      player << s
      deck.delete(s)
      s = deck.sample
      dealer << s
      deck.delete(s)
    end
  end

  # save session
  session['dealer'] = dealer.to_json
  session['player'] = player.to_json
  session['deck'] = deck.to_json
  erb :blackjack, :locals => {'deck' => deck, 'dealer' => dealer, 'player' => player, 'game_over' => session[:game_over], 'player_sum' => session[:player_sum], 'dealer_sum' => session[:dealer_sum]}
end

post '/blackjack/hit' do
  deck = JSON.parse(session['deck'])
  card = deck.sample
  deck.delete(card)
  session['deck'] = deck.to_json
  player = JSON.parse(session['player']) << card
  session['player'] = player.to_json
  # check bust / win
  sum = 0
  player.each do |card|
    if card[0] == 'ace'
      if sum + 11 > 21
        sum += 1
      else
        sum += 11
      end

    elsif card[0] == 'king' || card[0] == 'jack' || card[0] == 'queen'
      sum += 10
    else
      sum += card[0].to_i
    end
  end
  session['player_sum'] = sum
  redirect to("/blackjack/stay") if sum > 21
  redirect to('/blackjack')
end

get '/blackjack/stay' do
  dealer = JSON.parse(session['dealer'])
  deck = JSON.parse(session['deck'])
  sum = 0
  dealer.each do |card|
    if card[0] == 'ace'
      if sum + 11 > 21
        sum += 1
      else
        sum += 11
      end
    elsif card[0] == 'king' || card[0] == 'jack' || card[0] == 'queen'
      sum += 10
    else
      sum += card[0].to_i
    end
  end
  until sum >= 17
    s = deck.sample
    sum += s[0].to_i
    dealer << s
    deck.delete(s)
  end
  session['game_over'] = true
  session['deck'] = deck.to_json
  session['dealer'] = dealer.to_json
  session['dealer_sum'] = sum
  redirect '/blackjack'
end
