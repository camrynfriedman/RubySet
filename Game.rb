require_relative 'Deck.rb'
require_relative 'Card.rb'
require 'colorize'
require 'time'

# main menu for beginning of game
def main_menu
    puts "Welcome to The Game of Set!\n Please select what you would like to do by entering one of the numbers below followed by 'return'"

    print "1. How to Play\n"
    print "2. Play the Game\n"
    print "3. Quit Game\n"

    game_option = gets.to_i #must convert to integer bc gets returns string
    while game_option != 1 && game_option != 2 && game_option != 3
        puts "Error! Please enter a valid option."
        puts "Please select what you would like to do by entering one of the numbers below followed by 'return'"
        print "1. How to Play\n"
        print "2. Play the Game\n"
        print "3. Quit Game\n"
        game_option = gets.to_i
    end
    if game_option == 1
        tutorial(false)
    elsif game_option == 2
        playGame()
    end
end

#explains how to play
def tutorial(inGame)
    puts "-------------------------------------------------------------------------------------------------------"
    puts "\n In the Game of Set, 12 cards are dealt face up on the table."
    puts "\nEach card has four features:"
    puts "1. SHAPE (oval, squiggle, diamond)"
    puts "2. COLOR (" + "red".colorize(:red) + ", " + "purple".colorize(:light_magenta) + ", " + "green".colorize(:green) + ")"
    puts "3. NUMBER (1, 2, 3)"
    puts "4. SHADING (filled, striped, open)\n\n"
    puts "The goal of the game is to get as many sets as possible.\n"
    #not sure about this^

    puts "A Set consists of 3 card where each of the card's features are the SAME on each card, or DIFFERENT on each card"
    puts "Example 1:\n"
    puts "Let's say you are given the following cards: \n"
    puts "============\t============\t============"
    puts "||" + "oval    ".colorize(:red) + "||\t||" + "oval    ".colorize(:red) + "||\t||" + "oval    ".colorize(:red) + "||"
    puts "||" + "2       ".colorize(:red) + "||\t||" + "2       ".colorize(:red) + "||\t||" + "2       ".colorize(:red) + "||"
    puts "||" + "open    ".colorize(:red) + "||\t||" + "striped ".colorize(:red) + "||\t||" + "filled  ".colorize(:red) + "||"
    puts "============\t============\t============"
    puts "\nThis is a set because all three cards have the same shape, the same color, the same number of symbols and they all have different shading.\n"
    puts "\nExample 2:\n"
    puts "Let's say you are given the following cards: \n"
    puts "============\t============\t============"
    puts "||" + "squiggle".colorize(:green) + "||\t||" + "oval    ".colorize(:light_magenta) + "||\t||" + "diamond ".colorize(:red) + "||"
    puts "||" + "1       ".colorize(:green) + "||\t||" + "2       ".colorize(:light_magenta) + "||\t||" + "3       ".colorize(:red) + "||"
    puts "||" + "striped ".colorize(:green) + "||\t||" + "striped ".colorize(:light_magenta) + "||\t||" + "striped ".colorize(:red) + "||"
    puts "============\t============\t============"
    puts "\nThis is a set because all three cards have different shapes, different colors, and different numbers of symbols and they all have the same shading.\n"
    puts "When you identify a correct set, the cards will be removed from the table and three new ones will appear.\n"
    puts "There's a chance that you are unable to identify any sets on the table. In this case, you can choose to add three new cards to the table."
    puts "You can exit at any time, be that when you are done playing or the deck is empty with no more sets."
    puts "-------------------------------------------------------------------------------------------------------"
    if !inGame
        #check on this^
        puts "\nNow that you know how to play, let's get to it!"

        print "What would you like to do?\n"
        print "1. Return to Main Menu\n"
        print "2. Play the Game\n"

        option = gets.to_i
        while option != 1 && option != 2
            print "Error! Invalid input."
            print "What would you like to do?\n"
            print "1. Return to Main Menu\n"
            print "2. Play the Game\n"
            option = gets.to_i
        end
        if option == 1
            main_menu()
        elsif option == 2
            playGame()
        end
    end
end

#gets card input from user
def getSetFromUser(currentTable)
    puts "\nPlease enter the row and column of the first card"
    print "Row: "
    card1R = gets.to_i
    print "Column: "
    card1C = gets.to_i

    puts "\nPlease enter the row and column of the second card"
    print "Row: "
    card2R = gets.to_i
    print "Column: "
    card2C = gets.to_i

    puts "\nPlease enter the row and column of the third card"
    print "Row: "
    card3R = gets.to_i
    print "Column: "
    card3C = gets.to_i

    width = currentTable.length / 3
    newSet = [currentTable[width*(card1R-1)+card1C-1], currentTable[width*(card2R-1)+card2C-1], currentTable[width*(card3R-1)+card3C-1]]
    return newSet
end

#checks attributes of each card to see if they are the same
def checkEachCharacteristic(char1, char2, char3)
    result = false
    if char1 == char2 && char2 == char3
            result = true
    elsif char1 != char2 && char2 != char3 && char1 != char3
            result = true
    end

    return result
end

def checkIfSet(card1, card2, card3)
    #need to check each characterisitc to make a set
    isSet = false
    if(checkEachCharacteristic(card1.symbol, card2.symbol, card3.symbol) && checkEachCharacteristic(card1.color, card2.color, card3.color) && checkEachCharacteristic(card1.numSym, card2.numSym, card3.numSym) && checkEachCharacteristic(card1.shade, card2.shade, card3.shade))
        isSet = true
    end
    
    return isSet
end

#method to add three cards to the board
def addThreeCards(currentTable, deck1)
    width = currentTable.length / 3
    for i in 1..3 do
        j = ((width + 1) * i) - 1 #determines array index where new cards should be placed
        currentTable.insert(j, deck1.dealCard)
    end
end

def replaceSet(card1, card2, card3, tableCards, deck1)
    #choose one of the two methods depending on which works better with the rest of the code available
    for x in tableCards
        if(x == card1 || x == card2 || x == card3)
            i = tableCards.index(x)
            tableCards.delete_at(i)
            if (tableCards.length < 12)
                tableCards.insert(i,deck1.cards.pop)
            end
        end
    end
end

#TODO - FIGURE OUT IF WE WANT TO JUST CALL THE PRINT
#TABLE METHOD WITH THE UPDATED DEALT CARDS ARRAY EACH TIME
#OR IF WE WANT TO HAVE A PRINTINITIALTABLE METHOD
#AND THEN WHEN CARDS ARE ADDED/REMOVED DO SOMETHING
#ELSE FOR PRINTING.

#Code to properly print, edge to edge, a card trait
def printTrait(color, trait, remaining)
    #print the card's starting edge
    print "||"

    #print the trait, colorized
    if color == "purple"
        print trait.colorize(:magenta)
    elsif color == "green"
        print trait.colorize(:green)
    else
        print trait.colorize(:red)
    end

    #print spaces to a set width based on text
    for k in 1..remaining do
        print " "
    end

    #print the end edge, and create space between the next card
    print "||\t"
end

#prints the game table given the dealt cards array
def printTable(cards)
    width = cards.length / 3
    for i in 0..2 do
        #print tops of cards
        for j in 0..(width-1) do
            print "============\t"
        end
        puts
        #print all the symbols, then all the numbers, then all the shadings
        for j in 0..(width-1) do
            #Get the color to colorize text to
            color = cards[width*i+j].color

            #get the symbol, and how many spaces to print
            trait = cards[width*i + j].symbol

            printTrait(color,trait,8 - trait.length)
        end
        puts

        for j in 0..(width-1) do
            #Get the color to colorize text to
            color = cards[width*i+j].color

            #get the number
            trait = cards[width*i + j].numSym

            printTrait(color,trait.to_s,7)
        end
        puts

        for j in 0..(width-1) do
            #Get the color to colorize text to
            color = cards[width*i+j].color

            #get the shade, and how many spaces to print
            trait = cards[width*i + j].shade

            printTrait(color,trait,8-trait.length)
        end
        puts

        #print bottoms of cards
        for j in 0..(width-1) do
            print "============\t"
        end
        puts "\n\n"
    end
end

#prints options of what to do during the game
def printOptions(isEmpty)
    print "What would you like to do? (Type the number then press 'return')\n"
    print "1. Choose a set.\n"
    print "2. View the tutorial.\n"
    if !isEmpty
        print "3. Add 3 cards to the table\n"
    end
    print "4. Quit game\n"
    print "Your Input: "
end


def playGame
    print "Let's play!\n"
    startTime = Time.now
    #initialize deck
    deck1 = Deck.new()
    #shuffle deck
    deck1.cards.shuffle!
    #deal 12 cards and add to an array tableCards
    tableCards = []
    for i in 1..12 do
        tableCards << deck1.dealCard #simultaneously removes each card from the deck
    end

    wantsToPlay = true
    potentialSet = []
    setCount = 0

    while deck1.cards.length >= 0 and wantsToPlay do
        #given tableCards, print table
        printTable(tableCards)

        inputInvalid = true
        printOptions(deck1.cards.length == 0)

        #maybe check for invalid option w loop
        while inputInvalid
            inputInvalid = false
            option = gets.to_i
            if option == 1
                potentialSet = getSetFromUser(tableCards)
                if (potentialSet[0] == potentialSet[1]) || (potentialSet[0] == potentialSet[2]) || (potentialSet[1] == potentialSet[2])
                    puts("\nYou can't choose the same card more than once!\n\n")
                else
                    if checkIfSet(potentialSet[0], potentialSet[1], potentialSet[2])
                        puts "\nSet found!\n\n"
                        setCount = setCount + 1
                        replaceSet(potentialSet[0], potentialSet[1], potentialSet[2], tableCards, deck1)
                    else
                        puts "\nNot a Set! Try Again!\n\n"
                    end
                end
            elsif option == 2
                tutorial(true)
            elsif (option == 3) && (deck1.cards.length > 0)
                addThreeCards(tableCards,deck1)
            elsif option == 3
                puts("\nThe deck is empty\n\n")
            elsif option == 4
                wantsToPlay = false
            else
                inputInvalid = true
                puts "Error, invalid input. Please enter new input!"
            end
        end
    end
    endTime = Time.now
    print "Game over! You played for " + (endTime - startTime).to_i.to_s + " seconds and found " + setCount.to_s + " sets.\n"
end

main_menu