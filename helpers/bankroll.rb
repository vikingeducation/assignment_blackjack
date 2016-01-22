module Bankroll

  def update_bankroll(outcome)
    if outcome == 'win'
      increase_bankroll
    elsif outcome == 'loss' || outcome == 'dealer21'
      decrease_bankroll
    elsif outcome == 'player21'
      blackjack
    end
    session[:outcome] = outcome
  end

  def blackjack
    session[:bankroll] = (session[:bankroll].to_i + session[:bet].to_i*(1.5)).to_s
  end

  def increase_bankroll
    session[:bankroll] = (session[:bankroll].to_i + session[:bet].to_i).to_s
    session[:bet] = nil
  end

  def decrease_bankroll
    session[:bankroll] = (session[:bankroll].to_i - session[:bet].to_i).to_s
    session[:bet] = nil
  end

  def check_bet?(bankroll, bet)
    bankroll >= bet
  end
end