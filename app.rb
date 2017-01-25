require 'sinatra'
require './helpers/game.rb'

enable :sessions

get '/' do
  session['bankroll'] = nil
  erb :home
end

get '/blackjack' do
  session['game'] = Game.new
  session['player'] = Player.new(bankroll: session['bankroll'])
  session['bankroll'] = session['player'].bankroll
  erb :blackjack, locals: { bankroll: session['bankroll'], alert: false }
end

post '/blackjack/bet' do
  session['bet'] = params[:bet].to_f
  if session['player'].valid_bet?(session['bet'])
    erb :show_game, locals: { bankroll: session['bankroll'], bet: session['bet'], show_cards: false }
  else
    erb :blackjack, locals: { bankroll: session['bankroll'], alert: true }
  end
end

post '/blackjack/deal_cards' do
  session['bankroll'] += session['bet'] * 1.5 if session['game'].status == 'blackjack' ## float 3/2
  session['bankroll'] -= session['bet'] if session['game'].status == 'lose'
  erb :show_game, locals: { bankroll: session['bankroll'], bet: session['bet'], show_cards: true, game: session['game'] }
end

post '/blackjack/hit' do
  session['game'].hit
  session['bankroll'] -= session['bet'] if session['game'].status == 'lose'
  erb :show_game, locals: { bankroll: session['bankroll'], bet: session['bet'], show_cards: true, game: session['game'] }
end

post '/blackjack/stay' do
  session['game'].stay
  session['bankroll'] += session['bet'] if session['game'].status == 'win'
  session['bankroll'] -= session['bet'] if session['game'].status == 'lose'
  erb :show_game, locals: { bankroll: session['bankroll'], bet: session['bet'], show_cards: true, game: session['game'] }
end

post '/blackjack/play_again' do
  redirect to('/blackjack')
end