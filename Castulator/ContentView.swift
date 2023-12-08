//
//  ContentView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 11/28/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            QuickCastView()
            CustomFunctionListView()
        }
        .tint(.primary)
    }
}
