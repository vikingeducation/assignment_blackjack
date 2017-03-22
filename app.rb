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
  Blackjack.new(c1, c2)
end

def save_cards!(c1, c2)
  session[:cards1] = c1.to_json
  session[:cards2] = c2.to_json
end

def deal_hands!(bj)
  c1, c2 = bj.p1[:cards], bj.p2[:cards]
  if c1.empty? && c2.empty?
    bj.deal_hands!(2)
    save_cards!(c1, c2)
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
  if bj.get_score(bj.p1[:cards]) > 21
    return redirect to("/blackjack/stay")
  end
  save_cards!(bj.p1[:cards], bj.p2[:cards])
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

post "/blackjack/hit" do
  bj = load_game_state
  hit!(bj)
  redirect to("/blackjack")
end
