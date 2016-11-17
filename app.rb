#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'

enable :sessions

get '/' do
  session[:user] ||= true #maybe should be string?
  session[:bankroll] ||= 1000

  erb :landing, locals: { bankroll: session[:bankroll] }
end

get '/blackjack' do

end
