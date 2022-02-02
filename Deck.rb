class Deck


    def initialize
        deck = []
        symbols = ["squiggle", "diamond", "oval"]
        colors = ["red", "green", "blue"]
        numSymbols = [1, 2, 3]
        shades = ["filled", "striped", "open"]

        for i in symbols
            for j in colors
                for k in numSymbols
                    for l in shades
                        deck << Card.new(i, j, k, l)
                    end
                end
            end
        end
    end

    deck1 = Deck.new()
    puts deck1

    def dealCard
        #pop off array

    end
end

