module DealerHelper
  def dealer_play
    while sum_points(session['dealer_cards']) < 17
      hit_me(session['dealer_cards'])
    end
  end
end