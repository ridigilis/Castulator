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
    @State var result: QuickCastResult? = nil
    var results: [QuickCastResult]
    
    var body: some View {
        Button {
            result = QuickCastResult(die)
            modelContext.insert(result!)
            if results.count >= 100 {
                modelContext.delete(results[0])
            }
        } label: {
            ZStack {
                DynamicImage(die.rawValue).opacity(0.4)
                if result != nil {
                    Text(String(result!.value))
                        .font(
                            Font.custom("MedievalSharp", size: 48)
                        )
                }
            }
        }
        .padding()
        .gesture(
            DragGesture(minimumDistance: 10, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.width < 0 || value.translation.width > 0 {
                        result = nil
                    }
                }
        )
    }
}
