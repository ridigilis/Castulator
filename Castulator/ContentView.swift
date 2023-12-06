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
                ToolbarItemGroup {
                        NavigationLink {
                            VStack {
                                if results.isEmpty {
                                    Text("No Cast Result History to show.").font(.subheadline).opacity(0.6)
                                    Text("Try casting some dice!").font(.subheadline).opacity(0.6)
                                } else {
                                    List(results.sorted(by: {$0.castDate > $1.castDate})) { res in
                                        HStack {
                                            CastResultHistoryView(result: res)
                                        }
                                        .frame(maxHeight: 64)
                                        .listRowBackground(Color.clear)
                                        .listRowSeparator(.hidden)
                                    }
                                }
                            }
                            .navigationTitle("Cast History")
                            .scrollContentBackground(.hidden)
                            .background { Image("parchment") }
                            .toolbar {
                                Button("Clear") {
                                    results.forEach { modelContext.delete($0) }
                                }.disabled(results.isEmpty)
                            }
                        } label: {
                            Image(systemName: "list.number")
                        }

                        NavigationLink {
                            CustomFunctionListView()
                                .navigationTitle("Custom Functions")
                                .scrollContentBackground(.hidden)
                                .background { Image("parchment") }
                        } label: {
                            Image(systemName: "fn")
                        }
                    
                }
            }
        }.tint(.primary)
    }
}
