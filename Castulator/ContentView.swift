//
//  ContentView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 11/28/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Roll Result goes here!")
            Spacer()
            
            Grid {
                GridRow {
                    Button {} label: {
                        Image("d4").resizable().scaledToFit()
                    }
                    Button {} label: {
                        Image("d6").resizable().scaledToFit()
                    }
                    Button {} label: {
                        Image("d8").resizable().scaledToFit()
                    }
                    Button {} label: {
                        Image("d10").resizable().scaledToFit()
                    }
                }
                GridRow {
                    Button {} label: {
                        Image("d12").resizable().scaledToFit()
                    }
                    Button {} label: {
                        Image("d20").resizable().scaledToFit()
                    }
                    Button {} label: {
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
