./helpers/bj_helper.rb

module BlackJackHelper

  def save_game(dealercards, playercards, gamestate)
    session[:playercards] = playercards
    session[:dealercards] = dealercards
    session[:gamestate] = gamestate
  end

end