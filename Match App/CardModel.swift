//
//  CardModel.swift
//  Match App
//
//  Created by Meredith Anderer on 4/13/22.
//

import Foundation

class CardModel {
    func getCards() -> [Card] {
        //Declare an empty array
        var generatedCards = [Card]()
        //create list of potential card numbers
        var cardNumbers = Array(1...13).shuffled()
        //Randomly generate 8 pairs of cards
        for _ in 1...8 {
            if let randomNumber = cardNumbers.popLast() {
                let imageName = "card\(randomNumber)"
                let card1 = Card(imageName)
                let card2 = Card(imageName)
                generatedCards += [card1, card2]
            }
        }
        //Randomize cards within the array
        generatedCards.shuffle()
        //Return the array
        return generatedCards
    }
}
