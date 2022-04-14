//
//  Card.swift
//  Match App
//
//  Created by Meredith Anderer on 4/13/22.
//

import Foundation

class Card {
    var imageName: String = ""
    var isMatched: Bool = false
    var isFlipped: Bool = false
    
    init(_ imageName: String) {
        self.imageName = imageName
    }
}
