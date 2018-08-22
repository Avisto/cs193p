//
//  Concentration.swift
//  Concentration
//
//  Created by Avisto on 21/08/2018.
//

import Foundation

struct Concentration {
    
    private var theme = Theme.self
    private(set) var cards = [Card]()
    private(set) var flipCount = 0
    private(set) var score: Double = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get { return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    //MARK: - Initialization
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(at: \(numberOfPairsOfCards)): you must have at least one pait of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
    
    //MARK: - Public methods

    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)):choosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                score += obtainScore(firstCard: cards[index], secondCard: cards[matchIndex])
                startMatchingTime = Date()
                cards[index].isFaceUp = true
                cards[index].didFlipOver = true
                cards[matchIndex].didFlipOver = true
                flipCount += 1
            } else {
                if indexOfOneAndOnlyFaceUpCard == nil {
                    flipCount += 1
                }
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }

    mutating func reset() {
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].didFlipOver = false
        }
        score = 0
        flipCount = 0
        indexOfOneAndOnlyFaceUpCard = nil
        cards.shuffle()
    }

    func obtainSet() -> (emoji: String, backsideColor: String, backgroundColor: String) {
        return theme.randomSet().description
    }
    
    //MARK: - Game score
    
    private enum MatchingState {
        case match
        case mismatch
        case doubleMismatch
        
        var value: (max: Double, average: Double, min: Double) {
            switch self {
            case .match:
                return (max: 2, average: 1.8, min: 1.5)
            case .mismatch:
                return (max: -0.5, average: -0.8, min: -1)
            case .doubleMismatch:
                return (max: -1.5, average: -1.8, min: -2)
            }
        }
    }
    
    private var startMatchingTime: Date?
    private var matchingTime: TimeInterval {
        get {
            return Date().timeIntervalSince(startMatchingTime == nil ? Date() : startMatchingTime!)
        }
    }

    private func obtainScore(firstCard: Card, secondCard: Card) -> Double {
        func obtainScore(matchingState: MatchingState, matchingTime: TimeInterval) -> Double {
            switch matchingTime {
            case 0...2:
                return matchingState.value.max
            case 2...4:
                return matchingState.value.average
            case 4...:
                return matchingState.value.min
            default:
                return matchingState.value.max
            }
        }
        
        if firstCard == secondCard {
            return obtainScore(matchingState: MatchingState.match, matchingTime: matchingTime)
        } else if firstCard.didFlipOver && secondCard.didFlipOver {
            return obtainScore(matchingState: MatchingState.doubleMismatch, matchingTime: matchingTime)
        } else if firstCard.didFlipOver || secondCard.didFlipOver {
            return obtainScore(matchingState: MatchingState.mismatch, matchingTime: matchingTime)
        }
        return 0
    }
    
}

// MARK: - Collection extention

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
