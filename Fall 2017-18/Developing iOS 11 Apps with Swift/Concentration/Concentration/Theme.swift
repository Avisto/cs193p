//
//  Theme.swift
//  Concentration
//
//  Created by Avisto on 21/08/2018.
//

import Foundation

enum Theme: UInt32 {
    case animals
    case sports
    case smileys
    case flags
    case gestures
    case buildings
    
    private static let count: Theme.RawValue = {
        var maxValue: UInt32 = 0
        while let _ = Theme(rawValue: maxValue) {
            maxValue += 1
        }
        return maxValue
    }()
    
    var description: (emoji: String, backsideColor: String, backgroundColor: String) {
        switch self {
        case .animals:
            return (emoji: "🐶🦊🐷🦆🐴🐑🐈🐿🦔", backsideColor: "#826c95", backgroundColor: "#355C7D")
        case .sports:
            return (emoji: "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓", backsideColor: "#E84A5F", backgroundColor: "#2A363B")
        case.smileys:
            return (emoji: "😀☺️🤪🤔🤮🤫🤯😭😳", backsideColor: "#6bbc9d", backgroundColor: "#b5c59e")
        case .flags:
            return (emoji: "🇱🇷🇦🇹🇧🇷🇨🇦🇰🇾🇹🇩🇩🇪🇯🇵🇪🇸", backsideColor: "#F7DB4F", backgroundColor: "#2F9599")
        case .gestures:
            return (emoji: "🤞✌️🤟👌🤙👍👎✋🖕", backsideColor: "#547980", backgroundColor: "#594F4F")
        case .buildings:
            return (emoji: "🏣🏤🏥🏦🏨🏪🏫💒🏭", backsideColor: "#FC9D9A", backgroundColor: "#F9CDAD")
        }
    }
    
    static func randomSet() -> Theme {
        let rand = arc4random_uniform(Theme.count)
        return Theme(rawValue: rand)!
    }
    
}
