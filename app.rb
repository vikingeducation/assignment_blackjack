require 'sinatra'
require 'thin'
require 'sinatra/reloader' if development?

enable :sessions

get '/' do
  erb :home
end

get '/play' do
  erb :game
end
