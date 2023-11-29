//
//  ContentView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 11/28/23.
//

import SwiftUI

enum Dice: String {
    case d4, d6, d8, d10, d12, d20, d100
}

struct Result {
    let value: UInt
    let die: Dice

    init(_ die: Dice) {
        switch die {
        case .d4: self.value = UInt.random(in: 1...4)
        case .d6: self.value = UInt.random(in: 1...6)
        case .d8: self.value = UInt.random(in: 1...8)
        case .d10: self.value = UInt.random(in: 0...9)
        case .d12: self.value = UInt.random(in: 1...12)
        case .d20: self.value = UInt.random(in: 1...20)
        case .d100: self.value = UInt.random(in: 0...99)
        }
        
        self.die = die
    }
        
    func getDiceImageView() -> some View {
        switch self.die {
        case .d4: Image("d4").resizable().scaledToFit().opacity(0.15)
        case .d6: Image("d6").resizable().scaledToFit().opacity(0.15)
        case .d8: Image("d8").resizable().scaledToFit().opacity(0.15)
        case .d10: Image("d10").resizable().scaledToFit().opacity(0.15)
        case .d12: Image("d12").resizable().scaledToFit().opacity(0.15)
        case .d20: Image("d20").resizable().scaledToFit().opacity(0.15)
        case .d100: Image("d100").resizable().scaledToFit().opacity(0.15)
        }
    }
}

struct ContentView: View {
    @State private var result: Result?
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                if result != nil {
                    result!.getDiceImageView()
                    Text(String(result!.value))
                        .opacity(0.6)
                        .font(
                            Font.custom("MedievalSharp", size: 84)
                        )
                } else {
                    Image("d20").resizable().scaledToFit().opacity(0.25)
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
                    Button {
                        result = Result(.d4)
                    } label: {
                        Image("d4").resizable().scaledToFit()
                    }
                    Button {
                        result = Result(.d6)
                    } label: {
                        Image("d6").resizable().scaledToFit()
                    }
                    Button {
                        result = Result(.d8)
                    } label: {
                        Image("d8").resizable().scaledToFit()
                    }
                    Button {
                        result = Result(.d10)
                    } label: {
                        Image("d10").resizable().scaledToFit()
                    }
                }
                GridRow {
                    Button {
                        result = Result(.d12)
                    } label: {
                        Image("d12").resizable().scaledToFit()
                    }
                    Button {
                        result = Result(.d20)
                    } label: {
                        Image("d20").resizable().scaledToFit()
                    }
                    Button {
                        result = Result(.d100)
                    } label: {
                        Image("d100").resizable().scaledToFit()
                    }
                }
            }
        }
        .padding()
        .background(Image("parchment"))
    }
}

#Preview {
    ContentView()
}
