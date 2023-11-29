//
//  ContentView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 11/28/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var results: [CastResult]
    @State private var result: CastResult?
    @State private var showHistorySheet = false
    
    let dateFormatter = RelativeDateTimeFormatter()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                if result != nil {
                    CastResultView(result: result!)
                } else {
                    ZStack {
                        Image("d20").resizable().scaledToFit().opacity(0.15)
                        Text("Castulator")
                            .opacity(0.6)
                            .font(
                                Font.custom("MedievalSharp", size: 42)
                            )
                    }
                }
                
                Spacer()
                
                Grid {
                    GridRow {
                        DiceButton(die: .d2, result: $result, results: results)
                        DiceButton(die: .d4, result: $result, results: results)
                        DiceButton(die: .d6, result: $result, results: results)
                        DiceButton(die: .d8, result: $result, results: results)
                    }
                    
                    GridRow {
                        DiceButton(die: .d10, result: $result, results: results)
                        DiceButton(die: .d12, result: $result, results: results)
                        DiceButton(die: .d20, result: $result, results: results)
                        DiceButton(die: .d100, result: $result, results: results)
                    }
                }
            }
            .padding()
            .background(Image("parchment"))
            .toolbar {
                Button("History") {
                    showHistorySheet.toggle()
                }.font(Font.custom("MedievalSharp", size: 16))
            }
            .sheet(isPresented: $showHistorySheet, content: {
                List(results.sorted(by: {$0.castDate > $1.castDate})) { res in
                    HStack {
                        CastResultView(result: res)
                        Text("\(dateFormatter.localizedString(fromTimeInterval: res.castDate.timeIntervalSinceNow))")
                    }
                }
            })
        }
    }
}

//#Preview {
//    ContentView()
//}
