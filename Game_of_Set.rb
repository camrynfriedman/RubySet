require_relative 'Ui'
require_relative 'Core'


ui = GameUI.new
playerCount = ui.welcome
g = GameCore.new(playerCount)
if playerCount == 1
  countdown_time_in_seconds = g.get_game_mode_time()
  timer = Thread.new do
    countdown_time_in_seconds.downto(0) do |i|
      sleep 1
    end
    puts
    puts 'Time is up.'
    ui.game_over(g.player_scores)
    puts "Thank you for playing our game!"
    exit(0)
  end
end


ui.show_all_cards(g.flipped_cards)
pc = Array.new()
userOption = ui.main_menu
while true
  case userOption
  when 1
    max_column = g.flipped_cards[0].length
    startTime = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    pc = ui.choose_cards(max_column)
    while g.equalCheck(pc)
      pc = ui.choose_cards(max_column)
    end
    endTime = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    timeTaken = endTime - startTime
    card1, card2, card3 = g.flipped_cards[pc[0][0]][pc[0][1]], g.flipped_cards[pc[1][0]][pc[1][1]], g.flipped_cards[pc[2][0]][pc[2][1]]
    bool = g.check(card1, card2, card3)
    if bool == true
      playerNum = ui.play_right_prompt(playerCount)
      ui.printSet(pc, g.flipped_cards)
      puts "Time taken: #{timeTaken.round(2)} seconds"
      g.add_point(playerNum, pc)
      ui.show_all_cards(g.flipped_cards)
      pc.clear()
    else
      ui.play_wrong_prompt
      puts "Time taken: #{timeTaken.round(2)} seconds"
      pc.clear()
    end
    userOption = ui.main_menu
  when 2
    ui.game_over(g.player_scores)
    puts "Thank you for playing our game!"
    exit(0)
  when 3
    cards = g.exists_set
    ui.show_set(cards, g.flipped_cards)
    userOption = ui.main_menu
  when 4
    g.replace3help
    ui.show_all_cards(g.flipped_cards)
    userOption = ui.main_menu
  when 5
    if g.add3 == false
      ui.game_over(g.player_scores)
      exit(0)
    else
      ui.show_all_cards(g.flipped_cards)
      userOption = ui.main_menu
    end
  else
    puts 'You have entered an invalid option, please enter a valid option 1-3'
    userOption = gets.to_i
  end
end
if playerCount == 1
  timer.join
end
ui.game_over(g.player_scores)
puts "Thank you for playing our game!"
exit(0)