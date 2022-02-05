require 'colorize'
require_relative 'Card.rb'
class Deck
    attr_accessor :cards

    def initialize
        @cards = []
        symbols = ["oval", "squiggle", "diamond"]
        colors = ["red", "purple", "green"]
        numSymbols = [1, 2, 3]
        shades = ["filled", "striped", "open"]

        #loop through each aspect of a card to create
        #deck of 81 unique cards
        for i in symbols
            for j in colors
                for k in numSymbols
                    for l in shades
                        @cards << Card.new(i, j, k, l)
                    end
                end
            end
        end
    end

    def dealCard
        #pop off array
        @cards.pop
    end
end

