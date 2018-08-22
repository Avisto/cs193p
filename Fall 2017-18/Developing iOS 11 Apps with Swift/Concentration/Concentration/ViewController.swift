//
//  ViewController.swift
//  Concentration
//
//  Created by Avisto on 21/08/2018.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Interface
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var scoreLabel: UILabel! {
        didSet {
            updateScoreLabel()
        }
    }
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    private lazy var gameSet = game.obtainSet()
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    private(set) var score: Double = 0 {
        didSet {
            updateScoreLabel()
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor(hex: gameSet.backgroundColor)
    }
    
    override func viewDidLoad() {
        updateViewFromModel()
    }
    
    //MARK: - IBAction
    
    @IBAction private func newGame() {
        game.reset()
        gameSet = game.obtainSet()
        updateViewFromModel()
        self.view.backgroundColor = UIColor(hex: gameSet.backgroundColor)
        DispatchQueue.global(qos: .userInteractive).sync {
            self.emoji.removeAll()
        }
    }

    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else  {
            print("chosen card was not in cardButtons")
        }
    }
    
    //MARK: - Private methods
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private func updateScoreLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ]
        let attributedString = NSAttributedString(string: "Score: \(score)", attributes: attributes)
        scoreLabel.attributedText = attributedString
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : UIColor(hex: gameSet.backsideColor)
            }
        }
        flipCount = game.flipCount
        score = game.score
    }
    
    private var emoji = [Card: String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, gameSet.emoji.count > 0 {
            let randomStringIndex = gameSet.emoji.index(gameSet.emoji.startIndex, offsetBy: gameSet.emoji.count.arc4random)
            emoji[card] = String(gameSet.emoji.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
}

// MARK: - Int extention

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

// MARK: - UIColor extention

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var rgbValue: UInt32 = 0
        Scanner(string: hex).scanHexInt32(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}






