//
//  AppState.swift
//  Castulator
//
//  Created by Ricky David Groner II on 11/29/23.
//

import Foundation
import SwiftData

@Model
class AppState {
    var rollHistory: [CastResult] {
        didSet {
            if rollHistory.count > 100 {
                rollHistory = rollHistory.filter { $1 != 0 }
            }
        }
    }
    
    init() {
        self.rollHistory = [CastResult]()
    }
    
    func appendToRollHistory(_ result: CastResult) -> Void {
        rollHistory.append(result)
    }
}
