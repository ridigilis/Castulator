//
//  QuickCastView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 12/8/23.
//

import SwiftUI
import SwiftData

struct QuickCastView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Query private var results: [QuickCastResult]
    @State private var result: QuickCastResult?
    
    var body: some View {
        NavigationStack {
            Grid {
                GridRow {
                    DiceButton(die: .d20, results: results)
                    DiceButton(die: .d100, results: results)
                }
                
                GridRow {
                    DiceButton(die: .d10, results: results)
                    DiceButton(die: .d12, results: results)
                }
                
                GridRow {
                    DiceButton(die: .d6, results: results)
                    DiceButton(die: .d8, results: results)
                }
                
                GridRow {
                    DiceButton(die: .d2, results: results)
                    DiceButton(die: .d4, results: results)
                }
            }            
            .padding()
            .background(Image(colorScheme == .dark ? "parchment-dark" : "parchment-light").resizable().scaledToFill().ignoresSafeArea(.all).opacity(0.6))
            .toolbar {
                ToolbarItemGroup {
                    NavigationLink {
                        VStack {
                            if results.isEmpty {
                                Spacer()
                                Text("No Cast Result History to show.").font(.subheadline).opacity(0.6)
                                Text("Try casting some dice!").font(.subheadline).opacity(0.6)
                                Spacer()
                            } else {
                                List(results.sorted(by: {$0.castDate > $1.castDate})) { res in
                                    HStack {
                                        QuickCastResultHistoryView(result: res)
                                    }
                                    .frame(maxHeight: 64)
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                }
                            }
                        }
                        .navigationTitle("Cast History")
                        .scrollContentBackground(.hidden)
                        .background(Image(colorScheme == .dark ? "parchment-dark" : "parchment-light").resizable().scaledToFill().ignoresSafeArea(.all).opacity(0.6))
                        .toolbar {
                            Button("Clear") {
                                results.forEach { modelContext.delete($0) }
                            }.disabled(results.isEmpty)
                        }
                    } label: {
                        Image(systemName: "list.number")
                    }
                }
            }
        }
        .tabItem {
            Label("Quick Cast", systemImage: "dice.fill")
        }
    }
}

#Preview {
    QuickCastView()
}
