require "sinatra"
require "sinatra/reloader"
require "erb"

get "/" do
  erb :index
end
