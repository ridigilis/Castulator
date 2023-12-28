//
//  CastResult.swift
//  Castulator
//
//  Created by Ricky David Groner II on 11/29/23.
//

import Foundation
import SwiftData

@Model
class QuickCastResult {
    let value: UInt
    let die: Dice
    let castDate: Date

    init(_ die: Dice) {
        self.value = castDie(die)
        self.die = die
        self.castDate = .now
    }
}

enum Dice: String, Codable {
    case d2, d4, d6, d8, d10, d12, d20, d100
}

func castDie(_ die: Dice) -> UInt {
    switch die {
    case .d2: return UInt.random(in: 0...1)
    case .d4: return UInt.random(in: 1...4)
    case .d6: return UInt.random(in: 1...6)
    case .d8: return UInt.random(in: 1...8)
    case .d10: return UInt.random(in: 0...9)
    case .d12: return UInt.random(in: 1...12)
    case .d20: return UInt.random(in: 1...20)
    case .d100: return UInt.random(in: 0...99)
    }
}
