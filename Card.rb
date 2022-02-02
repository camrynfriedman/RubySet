# Single card class
class Card
    attr_reader :symbol, :color, :numSym, :shade
    def initialize(symbol, color, numSym, shade)
        @symbol = symbol
        @color = color
        @numSym = numSym
        @shade = shade
    end

    #overrides function so puts will print what is below
    def to_s
        "{@symbol}, {@color}, {@numSym}, {@shade}"
    end
end