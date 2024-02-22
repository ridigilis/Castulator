//
//  ContentView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 11/28/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CastulatorView()
            QuickCastView()
        }
        .tint(.primary)
    }
}

#Preview {
    ContentView()
}
