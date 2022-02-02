class GameUI


  def welcome
    puts 'Welcome to the game of set!'
    count = 6
    until count.to_i.between?(1,5)
      print 'Please enter player number:(1-5):'
      count = gets
    end
    count.to_i
  end

  def show_card_row(cards_row)
    max_column = cards_row.length
    card_face = [%w[Red Green Blue], %w[Ovals Squiggles Diamonds], %w[1 2 3], %w[Solid Open Striped]] # card feature in words
    max_column.times do # this loop print top of all cards
      print '____________  ' # 12 times
    end
    puts
    (0..3).each do |row| # each loop print one line of all cards
      (0...max_column).each do |column| # each loop print one line of one card
        temp = '|' + card_face[row][cards_row[column][row].to_i] # decode card from 4-digit string to features
        temp += ' ' until temp.length == 11
        print temp + '|  '
      end
      puts
    end
    max_column.times do # bottom of all cards
      print '------------  ' # 12 times
    end
    puts
  end


  def show_all_cards(cards)
    (0..2).each do |row| # each loop print one row of cards
      show_card_row(cards[row])
    end
    puts
  end

  def play_right_prompt(playerCount)
    puts 'Yay, you found a set!'
    player_num=6
    if playerCount == 1
      player_num = 1
    else
      until player_num.to_i.between?(1, 5)
        print 'Please enter your player number:'
        player_num = gets
      end
    end
    player_num.to_i
  end


  def play_wrong_prompt
    puts 'Sorry, that is not a set'
  end

  def main_menu
    player_order = 6
    until player_order.to_i.between?(1, 5)
      puts 'Main menu:'
      puts 'Enter 1 to enter a set'
      puts 'Enter 2 to exit the game.'
      puts 'Enter 3 to get a hint.'
      puts 'Enter 4 to replace 3 cards on the table.'
      puts 'Enter 5 to add 3 cards on the table'
      player_order = gets
    end
    player_order.to_i
  end


  def show_set(cards, flipped_cards)
    if cards[0][0] == 66
      puts 'No set available.'
      puts 'Please add 3 cards in main menu.'
    else
      puts 'HINT: A set contains: '
      card_feature = []
      (0..1).each do |i|
        card_feature.push flipped_cards[cards[i][0]][cards[i][1]]
      end
    end
    show_card_row(card_feature)
  end

  def game_over(player_scores)
    playerIndex = 0
    if player_scores.length == 1
      puts 'You got a total score of ' + player_scores[0].to_s + '!'
    else
      begin
        print 'Player ' + (playerIndex+1).to_s + ','
        puts 'Your score is: ' + player_scores[playerIndex].to_s + '.'
        playerIndex += 1
      end while playerIndex < player_scores.length
      if player_scores.uniq.length == 1
        puts 'Wow, everyone got the same score!'
      else
        highest_score = player_scores.max(1)[0]
        (0..player_scores.length).each do |i|
          if player_scores[i] == highest_score
            puts "Congratulations, Player #{i+1}!"
            puts 'You got the highest score!'
          end
        end
      end
    end
  end


  def printSet(pc, flipped_cards)
    set = [flipped_cards[pc[0][0]][pc[0][1]], flipped_cards[pc[1][0]][pc[1][1]], flipped_cards[pc[2][0]][pc[2][1]]]
    puts 'The set you found: '
    show_card_row(set)
  end

  def choose_cards(max_column)
    puts 'Please choose set by entering the cards row and column'
    puts "Range of row is [1..3] and column is [1..#{max_column}]" # max_column is dynamic during game process
    puts 'Use white space to separate row and column' # the range of max_column is from 4 to 7
    ans = [[0, 0], [0, 0], [0, 0]]
    (0..2).each do |i|
      coord = %w[23 22]
      while coord.nil? || coord.length != 2 || !coord[0].to_i.between?(1, 3) || !coord[1].to_i.between?(1, max_column)
        print "Input card #{i + 1}: "
        coord = gets.split ' '
      end
      ans[i] = [coord[0].to_i - 1, coord[1].to_i - 1]
    end
    ans
  end

end
