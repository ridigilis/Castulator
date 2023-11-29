//
//  DiceButton.swift
//  Castulator
//
//  Created by Ricky David Groner II on 11/29/23.
//

import SwiftUI
import SwiftData

struct DiceButton: View {
    @Environment(\.modelContext) var modelContext
    var die: Dice
    @Binding var result: CastResult?
    var results: [CastResult]
    
    var body: some View {
        Button {
            result = CastResult(die)
            modelContext.insert(result!)
            if results.count >= 100 {
                modelContext.delete(results[0])
            }
        } label: {
            Image(die.rawValue).resizable().scaledToFit()
        }
    }
}
