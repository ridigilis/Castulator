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
                    .overlay(alignment: result != nil ? .topLeading : .center) {
                        Text(die.rawValue)
                            .font(Font.custom("MedievalSharp", size: 18))
                            .dynamicTypeSize(.xxLarge)
                            .background {
                                Capsule().colorInvert().padding(-4).opacity(0.6)
                            }.opacity(result != nil ? 0.75 : 1)
                    }
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
