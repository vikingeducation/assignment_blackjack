module Bankroll

  def update_bankroll(outcome)
  if outcome == 'win'
    increase_bankroll
  elsif outcome == 'loss'
    decrease_bankroll
    end
  end

  def increase_bankroll
    session[:bankroll] = (session[:bankroll].to_i + session[:bet].to_i).to_s
    session[:bet] = nil
  end

  def decrease_bankroll
    session[:bankroll] = (session[:bankroll].to_i - session[:bet].to_i).to_s
    session[:bet] = nil
  end

end