
class GameCore
  MAX_GAME_TIME = 999999

  def initialize(number)
    @player_scores = Array.new(number, 0)
    @deck = %w[0 1 2]
    3.times do
      @deck.length.times do
        pre = @deck.shift
        %w[0 1 2].each { |post| @deck.push(pre + post) }
      end
    end
    777.times {@deck.shuffle!}
    @flipped_cards = draw12
    @deck = redraw
  end
  attr_accessor :player_scores, :flipped_cards
  attr_reader :deck

  def draw
    @deck.pop if @deck.length.positive?
  end

  # Draw 12 cards from deck to create 2D-array of first 12 cards
  def draw12
    cards = Array.new(3) { Array.new(4) }
    (0..2).each do |row|
      (0..3).each do |column|
        cards[row][column] = draw
      end
    end
    cards
  end

  # Return the 12 cards drawn to deck, re-shuffle and draw another 12 until a set exists in flipped_cards
  def redraw
    cards = @deck
    while exists_set[0][0] == 66
      (0..2).each do |row|
        (0..3).each do |column|
          cards << @flipped_cards[row][column]
        end
      end
      cards.shuffle!
      @flipped_cards = draw12
    end
    cards
  end

  # card0, card1, card2 - cards to be checked
  # Check if selected cards make a valid set
  def check(card0, card1, card2)
    (0..3).each do |feature|
      unequal = 0
      unequal += 1 if card0[feature] != card1[feature]
      unequal += 1 if card1[feature] != card2[feature]
      unequal += 1 if card0[feature] != card2[feature]
      if unequal == 2
        case feature
        when 0
          puts 'HINT: Take a look at the colors of the cards'
        when 1
          puts 'HINT: Take a look at the shapes of the cards'
        when 2
          puts 'HINT: Take a look at the number of the cards'
        when 3
          puts 'HINT: Take a look at the shading of the cards'
        end
      end
      return false if unequal == 2
    end
    true
  end

  # Check if answer entered by user contain duplicates
  # set - set entered by user
  # Returns true if set does contain duplicate, false if all are unique
  def equalCheck(set)
    if set.uniq.length != 3
      puts '*** You entered duplicates, please enter your answer again ***'
      true
    else
      false
    end
  end

  # playerIndex - player number score to update
  # set - set entered by user
  def add_point(playerIndex, set)
    @player_scores[playerIndex-1] += 1 # add one point to given player
    puts 'Current player score: ' # show all player scores
    @player_scores.reduce (1) { |number, score| print "Player #{number}: "; puts score; number += 1}
    set.each { |a,b| b <=> a }
    set.each { |card| @flipped_cards[card[0]].delete_at(card[1]) } # delete set from flipped cards
    replace3(set)
  end

  # Replace or remove the 3 cards selected and re-align flipped_cards
  # set - the array of cards to replace or remove
  def replace3(set)
    if (@flipped_cards.reduce (0) { |sum, cur| sum + cur.length }) >= 12 # still have 12+ cars flipped after remove, align flipped cards
      puts 'You have equal to or more than 12 cars flipped, game continue'
      l = @flipped_cards[0].length
      until @flipped_cards[1].length == l && @flipped_cards[2].length == l
        longest = @flipped_cards.reduce { |memo, cur| memo.length > cur.length ? memo : cur }
        shortest = @flipped_cards.reduce { |memo, cur| memo.length < cur.length ? memo : cur }
        shortest.push longest.pop
        l = @flipped_cards[0].length
      end
      true
    else # flipped cards less than 12
      if @deck.length < 3 # remaining cards in deck less than 3
        puts 'Not enough cars in deck'
        false
      else # have enough cards in deck
        (0..2).each { |index| @flipped_cards[set[index][0]].push draw } # push card in to each set[index] row
        true
      end
    end
  end

  def exists_set
    ans = [[66, 66], [66, 66], [66, 66]]
    cards_copy = []
    hash_map = {}
    (0...@flipped_cards.length).each do |row|
      (0...@flipped_cards[0].length).each { |column| cards_copy.push @flipped_cards[row][column] }
      (0...@flipped_cards[0].length).each { |column| hash_map[@flipped_cards[row][column]] = row * 10 + column }
    end
    (0...cards_copy.length).each do |i|
      ((i + 1)...cards_copy.length).each do |j|
        target = ''
        (0..3).each do |feature|
          target += cards_copy[i][feature].to_i == cards_copy[j][feature].to_i ? cards_copy[i][feature] : (3 - cards_copy[i][feature].to_i - cards_copy[j][feature].to_i).to_s
        end
        next if hash_map[target].nil?

        ans[0][0] = hash_map[cards_copy[i]] / 10
        ans[0][1] = hash_map[cards_copy[i]] % 10
        ans[1][0] = hash_map[cards_copy[j]] / 10
        ans[1][1] = hash_map[cards_copy[j]] % 10
        ans[2][0] = hash_map[target] / 10
        ans[2][1] = hash_map[target] % 10
      end
    end
    ans
  end

  # Draw 3 cards and add them to flipped_cards
  # true: return main menu
  # false: game over
  def add3
    length = @flipped_cards[0].length
    if length < 7 # flipped cards < 21
      if @deck.length < 3 # check deck < 3
        if exists_set[0][0] == 66 # no set
          return false
        else # has set
          puts 'Not enough cards in deck. But exist set in board.'
        end
      else # check deck > 3
        puts 'Draw three cards from deck.'
        (0..2).each do |row| # draw cards
          @flipped_cards[row][length] = draw
        end
      end
    else # flipped cards >= 21
      puts 'You can only have 21 cards on board.'
    end
    true
  end

  # Prompt user if they want a countdown if yes then prompt the countdown time
  # Countdown mode is only available for single player
  def get_game_mode_time
    puts "Choose a mode, 1 for normal mode, 2 for timer mode :)"
    mode = gets.to_i
    if mode == 2
      puts "Enter a count down time: "
      countdown_time = gets.to_i
    else
      countdown_time = MAX_GAME_TIME
    end
    countdown_time
  end

  # Replace the last card of each row when players need help
  def replace3help
    length = @flipped_cards[0].length
    (0..2).each do |row| # draw cards
      @deck.push @flipped_cards[row][length-1]
    end
    (0..2).each do |row| # draw cards
      @flipped_cards[row].pop
    end
    length-=1
    (0..2).each do |row| # draw cards
      @flipped_cards[row][length] = draw
    end
  end
end