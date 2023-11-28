//
//  ContentView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 11/28/23.
//

import SwiftUI

struct ContentView: View {
    @State private var result: UInt?
    
    enum Dice {
        case d4, d6, d8, d10, d12, d20, d100
    }
    
    func roll(_ die: Dice) -> UInt {
        switch die {
        case .d4: return UInt.random(in: 1...4)
        case .d6: return UInt.random(in: 1...6)
        case .d8: return UInt.random(in: 1...8)
        case .d10: return UInt.random(in: 0...9)
        case .d12: return UInt.random(in: 1...12)
        case .d20: return UInt.random(in: 1...20)
        case .d100: return UInt.random(in: 0...99)
        }
    }
    var body: some View {
        VStack {
            Spacer()
            
            result != nil
                ? Text(String(result!))
                : Text("Click any die below!")
            
            Spacer()
            
            Grid {
                GridRow {
                    Button { result = roll(.d4) } label: {
                        Image("d4").resizable().scaledToFit()
                    }
                    Button { result = roll(.d6) } label: {
                        Image("d6").resizable().scaledToFit()
                    }
                    Button { result = roll(.d8) } label: {
                        Image("d8").resizable().scaledToFit()
                    }
                    Button { result = roll(.d10) } label: {
                        Image("d10").resizable().scaledToFit()
                    }
                }
                GridRow {
                    Button { result = roll(.d12) } label: {
                        Image("d12").resizable().scaledToFit()
                    }
                    Button { result = roll(.d20) } label: {
                        Image("d20").resizable().scaledToFit()
                    }
                    Button { result = roll(.d100) } label: {
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
