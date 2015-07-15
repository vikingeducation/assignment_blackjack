#Given a time, calculate the angle between the hour and minute hands on a clock.

def calculate_angle(hours, minutes)
  raise "Invalid input" if (hours < 0 || hours > 12 || minutes > 60 || minutes < 0)

  hours = 0 if hours == 12
  minutes = 0 if minutes == 60

  minute_angle = 6 * minutes
  hour_angle = (hours * 60 + minutes) / 2

  (hour_angle - minute_angle).abs

end


p calculate_angle(12, 30)
p calculate_angle(1, 0)