
    def replaceSet(card1, card2, card3)
        #choose one of the two methods depending on which works better with the rest of the code available
        if(isSet)
            for x in tableCards
                if(x == card1 || x == card2 || x == card3)
                    i = tableCards.index(x)
                    tableCards.dealtCards.deleteAt(i)
                    tableCards.dealtCards.insert(i, Table.deck1.cards.pop.to_s)
                end
            end
        end
    end