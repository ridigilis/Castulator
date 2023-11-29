//
//  CastResult.swift
//  Castulator
//
//  Created by Ricky David Groner II on 11/29/23.
//

import Foundation
import SwiftData

@Model
class CastResult {
    let value: UInt
    let die: Dice
    let castDate: Date

    init(_ die: Dice) {
        switch die {
        case .d2: self.value = UInt.random(in: 0...1)
        case .d4: self.value = UInt.random(in: 1...4)
        case .d6: self.value = UInt.random(in: 1...6)
        case .d8: self.value = UInt.random(in: 1...8)
        case .d10: self.value = UInt.random(in: 0...9)
        case .d12: self.value = UInt.random(in: 1...12)
        case .d20: self.value = UInt.random(in: 1...20)
        case .d100: self.value = UInt.random(in: 0...99)
        }
        
        self.die = die
        self.castDate = .now
    }
}

enum Dice: String, Codable {
    case d2, d4, d6, d8, d10, d12, d20, d100
}
