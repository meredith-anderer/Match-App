//
//  ViewController.swift
//  Match App
//
//  Created by Meredith Anderer on 4/12/22.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cardsArray = [Card]()
    var firstFlippedCardIndex: IndexPath?
    var timer: Timer?
    var millisecondsLeftInGame: Int = 30 * 1000 //30 seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame()
    }
    
    //MARK: - CollectionView Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get a cell
        let cellToReturn = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
    
        // Return it
        return cellToReturn
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Configure the state of the cell based on the properties of the card that it represents
        // Get the appropriate card from the array
        let cardToDisplay = cardsArray[indexPath.row]
        // Configure a cell
        (cell as? CardCollectionViewCell)?.configureCell(cardToDisplay)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        if cell?.card?.isMatched == false {
            if cell?.card?.isFlipped == false {
                cell?.flipUp()
            } else {
                cell?.flipDown()
            }
            
        
        
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            } else {
                // Second card that is flipped — run the comparison logic
                checkForMatch(indexPath)
            }
        }
     
    }
    
    //MARK: - Game logic methods
    
    func checkForMatch(_ secondFlippedCardIndex: IndexPath) {
        guard let firstFlippedCardIndex = firstFlippedCardIndex, firstFlippedCardIndex != secondFlippedCardIndex else {
            self.firstFlippedCardIndex = nil
            return
        }
        let firstCardCell = collectionView.cellForItem(at: firstFlippedCardIndex) as? CardCollectionViewCell
        let secondCardCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        let firstCard = cardsArray[firstFlippedCardIndex.row]
        let secondCard = cardsArray[secondFlippedCardIndex.row]

        if firstCard.imageName == secondCard.imageName {
            firstCard.isMatched = true
            secondCard.isMatched = true
            firstCardCell?.remove()
            secondCardCell?.remove()
            // Was that the last pair?
            checkForWin()
        } else {
            firstCard.isFlipped = false
            secondCard.isFlipped = false
            firstCardCell?.flipDown(animate: true, delay: true)
            secondCardCell?.flipDown(animate: true, delay: true)
        }
        
        self.firstFlippedCardIndex = nil
    }
    
    func checkForWin() {
        for card in cardsArray {
            if card.isMatched == false {
                // If there is an unmatched card, the game has not been won
                // if there is no time left, show alert they lost
                if millisecondsLeftInGame <= 0 {
                    showAlert(title: "Time's up!", message: "Better luck next time.")
                }
                //If there is time left, dump out and continue
                return
            }
        }
        // If we make it through the loop without finding an unmatched card, the game was won
        // If game was won, show alert
        showAlert(title: "Congratulations!", message: "You've won the game!")
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        let alertAction = UIAlertAction.init(title: "Play Again", style: .default, handler: {_ in self.resetGame()} )
        alert.addAction(alertAction)
    }
    
    @objc func resetGame() {
        // Set up the cards
        cardsArray = model.getCards()
        collectionView.reloadData()
        firstFlippedCardIndex = nil
        // Set view controller as delegate and data source of the collectionview
        collectionView.dataSource = self
        collectionView.delegate = self
        //Initialize the timer
        millisecondsLeftInGame = 30 * 1000 //30 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    //MARK: - Timer methods
    @objc func timerFired() {
        //Decrement the counter
        millisecondsLeftInGame -= 1
        //Update the label
        let seconds:Double = Double(millisecondsLeftInGame)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        //Stop the timer if it reaches zero
        if millisecondsLeftInGame == 0 {
            timer?.invalidate()
            timerLabel.textColor = .red
            //Check if the user has cleared all the pairs
            checkForWin()
        }
        
    }

}

