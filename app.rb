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
  session['show_cards'] = false
  session['double_option'] = true
  session['double_alert'] = false
  session['split_alert'] = false
  erb :blackjack, locals: { bankroll: session['bankroll'], alert: false }
end

get '/blackjack/game' do
  erb :show_game, locals: { bankroll: session['bankroll'], bet: session['bet'], show_cards: session['show_cards'], game: session['game'], double_option: session['double_option'], double_alert: session['double_alert'], split_alert: session['split_alert'] }
end

post '/blackjack/bet' do
  session['bet'] = params[:bet].to_f
  if session['player'].valid_bet?(session['bet'])
    redirect to('/blackjack/game')
  else
    erb :blackjack, locals: { bankroll: session['bankroll'], alert: true }
  end
end

post '/blackjack/deal_cards' do
  session['bankroll'] += session['bet'] * 1.5 if session['game'].status == 'blackjack'
  session['bankroll'] -= session['bet'] if session['game'].status == 'lose'
  session['show_cards'] = true
  redirect to('/blackjack/game#cards')
end

post '/blackjack/hit' do
  session['game'].hit
  if (session['game'].split_game || session['game'].activate_split_cards) && session['game'].status_2 != 'ongoing'
    session['bankroll'] += session['bet'] if session['game'].status == 'win'
    session['bankroll'] -= session['bet'] if session['game'].status == 'lose'
    session['bankroll'] += session['bet'] * 1.5 if session['game'].status == 'blackjack'
    session['bankroll'] += session['bet'] if session['game'].status_2 == 'win'
    session['bankroll'] -= session['bet'] if session['game'].status_2 == 'lose'
    session['bankroll'] += session['bet'] * 1.5 if session['game'].status_2 == 'blackjack'
  elsif session['game'].status_2.nil?
    session['bankroll'] -= session['bet'] if session['game'].status == 'lose'
  end
  session['double_option'] = false
  session['double_alert'] = false
  session['split_alert'] = false
  redirect to('/blackjack/game#cards')
end

post '/blackjack/stay' do
  session['game'].stay
  if (session['game'].split_game || session['game'].activate_split_cards) && session['game'].status_2 != 'ongoing'
    session['bankroll'] += session['bet'] if session['game'].status == 'win'
    session['bankroll'] -= session['bet'] if session['game'].status == 'lose'
    session['bankroll'] += session['bet'] * 1.5 if session['game'].status == 'blackjack'
    session['bankroll'] += session['bet'] if session['game'].status_2 == 'win'
    session['bankroll'] -= session['bet'] if session['game'].status_2 == 'lose'
    session['bankroll'] += session['bet'] * 1.5 if session['game'].status_2 == 'blackjack'
  elsif session['game'].status_2.nil?
    session['bankroll'] += session['bet'] if session['game'].status == 'win'
    session['bankroll'] -= session['bet'] if session['game'].status == 'lose'
    session['bankroll'] += session['bet'] * 1.5 if session['game'].status == 'blackjack'
  end
  session['double_option'] = false
  session['double_alert'] = false
  session['split_alert'] = false
  redirect to('/blackjack/game#cards')
end

post '/blackjack/double' do
  session['bet'] *= 2
  session['double_option'] = false
  session['double_alert'] = true
  redirect to('/blackjack/game#cards')
end

post '/blackjack/split' do
  session['game'].split
  session['double_option'] = false
  session['double_alert'] = false
  session['split_alert'] = true
  redirect to('/blackjack/game#cards')
end

post '/blackjack/play_again' do
  redirect to('/blackjack')
end

post '/blackjack/start_over' do
  session['bankroll'] = 1000
  redirect to('/blackjack')
end