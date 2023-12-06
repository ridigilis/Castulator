//
//  CastulatorApp.swift
//  Castulator
//
//  Created by Ricky David Groner II on 11/28/23.
//

import SwiftUI
import SwiftData

@main
struct CastulatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().preferredColorScheme(.light)
        }
        .modelContainer(for: [CastResult.self, CustomFunction.self])
    }
}
