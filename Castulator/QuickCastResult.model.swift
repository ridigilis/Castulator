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
        self.value = Dice.castDie(die)
        self.die = die
        self.castDate = .now
    }
}
