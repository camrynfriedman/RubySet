require 'colorize'
# Single card class
class Card
    attr_reader :symbol, :color, :numSym, :shade
    def initialize(symbol, color, numSym, shade)
        @symbol = symbol
        @color = color
        @numSym = numSym
        @shade = shade
    end
end