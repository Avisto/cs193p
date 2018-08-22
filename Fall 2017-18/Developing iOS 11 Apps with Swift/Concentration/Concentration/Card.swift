//
//  Card.swift
//  Concentration
//
//  Created by Avisto on 21/08/2018.
//

struct Card: Hashable {
    
    var hashValue: Int {
        return identifier
    }
    
    public static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private var identifier: Int
    var isFaceUp = false
    var isMatched = false
    var didFlipOver = false
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
}

