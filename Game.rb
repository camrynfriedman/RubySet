require_relative 'Deck.rb','Card.rb'
require 'colorize'
    # main menu for beginning of game
    def main_menu
        puts "Welcome to The Game of Set!\n Please select what you would like to do by entering one of the numbers below followed by 'return'"
        puts "1. Play game.\n2. How to Play"

        game_option = gets.to_i #must convert to integer bc gets returns string
        while game_option != 1 && game_option != 2
            puts "Error! Please enter a valid option."
            puts "Please select what you would like to do by entering one of the numbers below followed by 'return'"
            puts "1. Play game.\n2. How to Play"
            game_option = gets.to_i
        end
        if game_option == 2
            tutorial()
        else
            playGame()
        end
    end

    #explains how to play
    def tutorial
        puts "\n In the Game of Set, 12 cards are dealt face up on the table."
        puts "\nEach card has four features:"
        puts "1. SHAPE (oval, squiggle, diamond)"
        puts "2. COLOR (" + "red".colorize(:red) + ", " + "purple".colorize(:light_magenta) + ", " + "green".colorize(:green) + ")"
        puts "3. NUMBER (1, 2, 3)"
        puts "4. SHADING (filled, striped, open)\n\n"
        puts "The goal of the game is to get as many sets as possible.\n"
        #not sure about this^
        puts ""

        puts "A Set consists of 3 card where each of the card's features are the SAME on each card, or DIFFERENT on each card"
        puts "Example 1:\n"
        puts "Let's say you are given the following cards: \n"
        puts "============\t============\t============"
        puts "||" + "oval ".colorize(:red) + "||\t||" + "oval".colorize(:red) + "||\t||" + "oval    ".colorize(:red) + "||"
        puts "||" + "2       ".colorize(:red) + "||\t||" + "2       ".colorize(:red) + "||\t||" + "2       ".colorize(:red) + "||"
        puts "||" + "open  ".colorize(:red) + "||\t||" + "striped    ".colorize(:red) + "||\t||" + "filled ".colorize(:red) + "||"
        puts "============\t============\t============"
        puts "\nThis is a set because all three cards have the same shape, the same color, the same number of symbols and they all have different shading.\n"
        puts "\nExample 2:\n"
        puts "Let's say you are given the following cards: \n"
        puts "============\t============\t============"
        puts "||" + "squiggle ".colorize(:green) + "||\t||" + "oval".colorize(:light_magenta) + "||\t||" + "diamond    ".colorize(:red) + "||"
        puts "||" + "1       ".colorize(:green) + "||\t||" + "2       ".colorize(:light_magenta) + "||\t||" + "3       ".colorize(:red) + "||"
        puts "||" + "striped  ".colorize(:green) + "||\t||" + "striped    ".colorize(:light_magenta) + "||\t||" + "striped ".colorize(:red) + "||"
        puts "============\t============\t============"
        puts "\nThis is a set because all three cards have different shapes, different colors, and different numbers of symbols and they all have the same shading.\n"
        puts "When you identify a correct set, the cards will be removed from the table and three new ones will appear.\n"
        puts "There's a chance that you are unable to identify any sets on the table. In this case, you can choose to add three new cards to the table."
        puts "In normal mode, the game will continue until all the cards are dealt and all the sets are found."
        #check on this^
        puts "\nNow that you know how to play, let's get to it!"

        print "What would you like to do?\n"
        print "1. Go back to main menu\n"
        print "2. Play the game\n"
        option = gets.to_i
        while option != 1 && option != 2
            print "Error! Invalid input."
            print "What would you like to do?\n"
            print "1. Go back to main menu\n"
            print "2. Play the game\n"
            option = gets.to_i
        end
        if option == 1
            main_menu()
        else
            playGame()
        end
    end

    #gets card input from user
    def getSetFromUser
        puts "Please enter the values of the cards in the following format: Row Column"
        print "Enter the first card in the set: "
        card1 = gets
        print "Enter the second card in the set: "
        card2 = gets
        print "Enter the third card in the set: "
        card3 = gets
        set = Array[card1, card2, card3]
        #not sure how to access these values from another fcn
    end

    #method to add three cards to the board
    def addThreeCards(currentTable)
        width = currentTable.length / 3 - 1
        for i in 1..3 do
            j = ((width + 1) * i) - 1 #determines array index where new cards should be placed
            currentTable.insert(j, Table.deck1.dealCard.to_s)
        end
    end
    #TODO - FIGURE OUT IF WE WANT TO JUST CALL THE PRINT
    #TABLE METHOD WITH THE UPDATED DEALT CARDS ARRAY EACH TIME
    #OR IF WE WANT TO HAVE A PRINTINITIALTABLE METHOD
    #AND THEN WHEN CARDS ARE ADDED/REMOVED DO SOMETHING
    #ELSE FOR PRINTING.

    #prints the game table given the dealt cards array
    def printTable(cards)
        width = cards.length / 3 - 1
        for i in 0..2 do
            #print tops of cards
            for j in 0..width do
                print "============\t"
            end
            puts
        #print all the symbols, then all the numbers, then all the shadings
        for j in 0..width do
            #Get the color to colorize text to
            color = cards[4*i+j].color

            #get the symbol, and how many spaces to print
            trait = cards[4*i + j].symbol

            printTrait(color,trait,8 - trait.length)
        end
        puts

        for j in 0..width do
            #Get the color to colorize text to
            color = cards[4*i+j].color

            #get the number
            trait = cards[4*i + j].numSym

            printTrait(color,trait.to_s,7)
        end
        puts

        for j in 0..width do
            #Get the color to colorize text to
            color = cards[4*i+j].color

            #get the shade, and how many spaces to print
            trait = cards[4*i + j].shade

            printTrait(color,trait,8-trait.length)
        end
        puts

        #print bottoms of cards
        for j in 0..width do
            print "============\t"
        end
        puts "\n\n"
    end

    #prints options of what to do during the game
    def printOptions
        print "What would you like to do? (Type the number then press 'return')\n"
        print "1. Choose a set.\n"
        print "2. View the tutorial.\n"
        print "3. Add 3 cards to the table\n"
        print "4. Quit game"
    end


    def playGame
        print "Let's play!\n"
        #initialize deck
        deck1 = Deck.new()
        #shuffle deck
        deck1.cards.shuffle!
        #deal 12 cards and add to an array dealtCards SEE TODO
        for i in 1..12 do
            dealtCards << deck1.dealCard #simultaneously removes each card from the deck
        end


        while deck1.length > 0 do
            #given dealtCards, print table
            printTable(dealtCards)

            #print options
            printOptions

            option = gets.to_i

            #maybe check for invalid option w loop

            if option == 1
            elsif option == 2
            elsif option == 3
            else
            end
            end



        #    getCards()
                #end
                #change to while loop
        #while not checkIfSet(card1, card2, card3)
            #print error message
        if checkIfSet(card1, card2, card3)
            puts "Congrats! You have found a set"
            replaceSet(card1, card2, card3)
        else
            puts "That is not a set, try again"
        end
    end






    #PLAY GAME
    #this is the actual code that's used to play the game. To run it, type 'ruby Game.rb' in a terminal.
    #call main menu -> use return value, say 'main_menu_return'
    #if main_menu_return == 1
        #call play game function
    #
    if mode_option == 1
                #play game
                #print the table of cards
                #print out the options like add three cards, make a selection etc
                #while(deck1.length>0) do
                #    getCards()
                #end

            else
                #game with timer
        #call main menu
        #self.main_menu
        #deal cards function
        #call function that asks user to identify set
        #check if set
        #call corresponding function (if set, replace the three cards. etc.)
