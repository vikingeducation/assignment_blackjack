
require 'sinatra'
require 'erb'
require './blackjack.rb'
require 'pry'

enable :sessions

include Blackjack

helpers do

  def initial_hands
    hand1 = []
    hand2 = []
    deal([], hand1)
    deal(hand1, hand2)
    deal(hand1 + hand2, hand1)
    deal(hand1 + hand2, hand2)

    return hand1, hand2
  end

  def card_to_hand(card)
    faces = {1 => "Ace", 11 => "Jack", 12 => "Queen", 13 => "King"}
    suits = {0 => "spades", 1 => "clubs", 2 => "hearts", 3 => "diamonds"}
    ret = ""
    if faces[(card % 13) + 1]
      value = faces[(card % 13) + 1]
    else
      value = (card % 13) + 1
    end
    ret += value.to_s
    ret += " of "
    ret += suits[(card / 13)]
  end

end


get '/' do
  'hello world'
end

get '/blackjack' do
  d_hand, p_hand = initial_hands
  session['d_hand'] = d_hand
  session['p_hand'] = p_hand
  erb :blackjack, locals: {d_hand: d_hand, p_hand: p_hand}
end

post '/blackjack/hit' do
  d_hand, p_hand = session['d_hand'], session['p_hand']
  deal(d_hand + p_hand, p_hand)
  session['d_hand'] = d_hand
  session['p_hand'] = p_hand
  redirect '/blackjack/stay', locals: {d_hand: d_hand, p_hand: p_hand} if bust(p_hand)
  erb :blackjack, locals: {d_hand: d_hand, p_hand: p_hand}
end

get '/blackjack/stay' do
  d_hand, p_hand = session['d_hand'], session['p_hand']
  erb :stay, locals: {d_hand: d_hand, p_hand: p_hand}
end