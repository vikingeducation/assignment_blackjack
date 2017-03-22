require "sinatra"
require "sinatra/reloader"
require "erb"
require "json"
require_relative "blackjack"

enable :sessions

# ------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------

def load_cards
  c1, c2 = session[:cards1], session[:cards2]
  return [[], []] if c1.nil?
  [c1, c2].map{ |c| JSON.parse(c, {symbolize_names: true}) }
end

def load_game_state
  c1, c2 = load_cards
  deck, bankroll = session[:deck], session[:bankroll]
  bet = session[:bet]
  opts = {cards1: c1, cards2: c2, deck: deck, bankroll: bankroll, bet: bet}
  Blackjack.new(opts)
end

def save_cards!(c1, c2)
  session[:cards1] = c1.to_json
  session[:cards2] = c2.to_json
end

def save_game_state!(bj)
  c1, c2 = bj.p1[:cards], bj.p2[:cards]
  save_cards!(c1, c2)
  session[:deck] = bj.deck
  session[:bankroll] = bj.bankroll
  session[:bet] = bj.bet
end

def deal_hands!(bj)
  c1, c2 = bj.p1[:cards], bj.p2[:cards]
  if c1.empty? && c2.empty?
    bj.deal_hands!(2)
    save_game_state!(bj)
  end
end

def reset_cards!
  session[:cards1], session[:cards2] = nil, nil
end

def reset_game_state!
  reset_cards!
end

def hit!(bj)
  bj.deal_card!(bj.p1)
  save_game_state!(bj)
  if bj.get_score(bj.p1[:cards]) > 21
    return redirect to("/blackjack/stay")
  end
end

# ------------------------------------------------------------------------
# Routes
# ------------------------------------------------------------------------

get "/" do
  erb :index
end

# show player and dealer hands
# save the deck of cards
get "/blackjack" do
  bj = load_game_state
  deal_hands!(bj)
  locals = {locals: {bj: bj}}
  erb :blackjack, locals
end

get "/blackjack/new-game" do
  reset_game_state!
  redirect to("/blackjack")
end

get "/blackjack/bet" do
  bj = load_game_state
  locals = {locals: {bj: bj}}
  erb :bet, locals
end

post "/blackjack/bet" do
  bet = params[:bet].to_i
  bj = load_game_state
  locals = {locals: {bj: bj}}
  if bj.bankroll < bet
    @msg = "You are poor. Place a smaller bet."
    erb :bet, locals
  else
    bj.bankroll -= bet
    bj.bet = bet
    save_game_state!(bj)
    redirect to("/blackjack")
  end
end

post "/blackjack/hit" do
  bj = load_game_state
  hit!(bj)
  redirect to("/blackjack")
end

get "/blackjack/stay" do
  bj = load_game_state
  while bj.get_score(bj.p2[:cards]) < 17
    bj.deal_card!(bj.p2)
  end
  save_game_state!(bj)
  redirect to("/blackjack/result")
end

get "/blackjack/result" do
  bj = load_game_state
  @result = bj.result
  locals = {locals: {bj: bj}}
  erb :blackjack, locals
end
