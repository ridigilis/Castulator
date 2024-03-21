//
//  DicePadView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 3/21/24.
//

import SwiftUI

struct DicePadView: View {
    var onDiceButtonPress: (Dice) -> Void
    var onOpButtonPress: (Operation) -> Void
    var onEqualsButtonPress: () -> Void
    var onClearButtonPress: () -> Void
    var onRerollLastButtonPress: () -> Void
    var onRerollAllButtonPress: () -> Void
    
    var body: some View {
        Grid {
            GridRow {
                Button {
                    onDiceButtonPress(.d20)
                } label: {
                    DynamicImage("d20")
                        .padding(-18)
                        .overlay {
                            Text("d20")
                                .font(Font.custom("MedievalSharp", size: 18))
                                .dynamicTypeSize(.medium)
                                .background {
                                    Capsule().colorInvert().padding(-4).opacity(0.6)
                                }
                        }
                }.padding()
                
                Button {
                    onDiceButtonPress(.d100)
                } label: {
                    DynamicImage("d100")
                        .padding(-24)
                        .overlay {
                            Text("d100")
                                .font(Font.custom("MedievalSharp", size: 18))
                                .dynamicTypeSize(.medium)
                                .background {
                                    Capsule().colorInvert().padding(-4).opacity(0.6)
                                }
                        }
                }.padding()
                
                Button {
                    onOpButtonPress(.divide)
                } label: {
                    DynamicImage(Operation.divide.toString)
                }.padding()
                
                Button {
                    onClearButtonPress()
                } label: {
                    Text("Clear").font(Font.custom("MedievalSharp", size: 18)).dynamicTypeSize(.large)
                }.padding()
            }
            
            GridRow {
                Button {
                    onDiceButtonPress(.d10)
                } label: {
                    DynamicImage("d10").padding(-24)
                        .overlay {
                            Text("d10")
                                .font(Font.custom("MedievalSharp", size: 18))
                                .dynamicTypeSize(.medium)
                                .background {
                                    Capsule().colorInvert().padding(-4).opacity(0.6)
                                }
                        }
                }.padding()
                
                Button {
                    onDiceButtonPress(.d12)
                } label: {
                    DynamicImage("d12").padding(-16)
                        .overlay {
                            Text("d12")
                                .font(Font.custom("MedievalSharp", size: 18))
                                .dynamicTypeSize(.medium)
                                .background {
                                    Capsule().colorInvert().padding(-4).opacity(0.6)
                                }
                        }
                }.padding()
                
                Button {
                    onOpButtonPress(.multiply)
                } label: {
                    DynamicImage(Operation.multiply.toString)
                }.padding()
                
                Button {
                    onRerollAllButtonPress()
                } label: {
                    Text("Reroll All").font(Font.custom("MedievalSharp", size: 16)).dynamicTypeSize(.large)
                }.padding()
            }
            
            GridRow {
                Button {
                    onDiceButtonPress(.d6)
                } label: {
                    DynamicImage("d6").padding(-18)
                        .overlay {
                            Text("d6")
                                .font(Font.custom("MedievalSharp", size: 18))
                                .dynamicTypeSize(.medium)
                                .background {
                                    Capsule().colorInvert().padding(-4).opacity(0.6)
                                }
                        }
                }.padding()
                
                Button {
                    onDiceButtonPress(.d8)
                } label: {
                    DynamicImage("d8").padding(-18)
                        .overlay {
                            Text("d8")
                                .font(Font.custom("MedievalSharp", size: 18))
                                .dynamicTypeSize(.medium)
                                .background {
                                    Capsule().colorInvert().padding(-4).opacity(0.6)
                                }
                        }
                }.padding()
                
                Button {
                    onOpButtonPress(.subtract)
                } label: {
                    DynamicImage(Operation.subtract.toString)
                }.padding()
                
                Button {
                    onRerollLastButtonPress()
                } label: {
                    Text("Reroll Last").font(Font.custom("MedievalSharp", size: 16)).dynamicTypeSize(.large)
                }.padding()
            }
            
            GridRow {
                Button {
                    onDiceButtonPress(.d2)
                } label: {
                    DynamicImage("d2").padding(-18)
                        .overlay {
                            Text("d2")
                                .font(Font.custom("MedievalSharp", size: 18))
                                .dynamicTypeSize(.medium)
                                .background {
                                    Capsule().colorInvert().padding(-4).opacity(0.6)
                                }
                        }
                }.padding()
                
                Button {
                    onDiceButtonPress(.d4)
                } label: {
                    DynamicImage("d4").padding(-18)
                        .overlay {
                            Text("d4")
                                .font(Font.custom("MedievalSharp", size: 18))
                                .dynamicTypeSize(.medium)
                                .background {
                                    Capsule().colorInvert().padding(-4).opacity(0.6)
                                }
                        }
                }.padding()
                
                Button {
                    onOpButtonPress(.add)
                } label: {
                    DynamicImage(Operation.add.toString)
                }.padding()
                
                Button {
                    onEqualsButtonPress()
                } label: {
                    DynamicImage("equals")
                }.padding()
            }
        }
    }
}
