class View
  def get_input(label = nil)
    puts label if label
    print '> '
    input = gets.chomp
    exit if input.start_with?('q') || input == "exit"
    input
  end

  def output(info = nil)
    puts info
  end
end
