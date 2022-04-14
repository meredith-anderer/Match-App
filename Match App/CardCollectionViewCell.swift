//
//  CardCollectionViewCell.swift
//  Match App
//
//  Created by Meredith Anderer on 4/13/22.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card: Card?
    func configureCell(_ card: Card) {
        // Keep track of the card the cell represents
        self.card = card
        
        // set the front image view to the image that represents the card
        frontImageView.image =  UIImage(named: card.imageName)
        
        // Reset the state of the cell for reuse purposes by checking the flipped status of the card and showing the right image
        if card.isMatched == true {
            frontImageView.alpha = 0
            backImageView.alpha = 0
            return
        } else {
            frontImageView.alpha = 1
            backImageView.alpha = 1
        }
        card.isFlipped ? flipUp(animate: false) : flipDown(animate: false)
        
     

    }
    
    func flipUp(animate: Bool = true) {
        let duration = animate ? 0.3 : 0
        UIView.transition(from: backImageView,
                          to: frontImageView,
                          duration: duration,
                          options: [.showHideTransitionViews, .transitionFlipFromLeft],
                          completion: nil)
        card?.isFlipped = true
    }
    
    func flipDown(animate: Bool = true, delay: Bool = false) {
        let delay = delay ? DispatchTime.now() + 0.5 : DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: delay, execute: {
            let duration = animate ? 0.3 : 0
            UIView.transition(from: self.frontImageView,
                              to: self.backImageView,
                              duration: duration,
                              options: [.showHideTransitionViews, .transitionFlipFromRight],
                              completion: nil)
        })
        card?.isFlipped = false

    }
    
    func remove() {
        backImageView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }

}
