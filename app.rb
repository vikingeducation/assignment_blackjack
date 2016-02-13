=begin
  1. Hello, World!

  We'll start by setting up the simplest possible Sinatra app.

  1. Set up a new Sinatra app in a file called app.rb. (DONE)
  2. Make the root URL display the unstyled text "Hello, World!" (don't even bother using a template yet) (DONE)
  3. Run your Sinatra server and verify that this works. (DONE)
  4. Create the home screen for the game. This is just a template welcome screen with a link to /blackjack, which will kick off the game. (DONE)
  5. Create a default layout with your boilerplate HTML code. (DONE)
  Don't forget to commit!
=end

require 'sinatra'

get '/' do
  erb :home
end