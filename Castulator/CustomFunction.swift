//
//  CustomFunction.swift
//  Castulator
//
//  Created by Ricky David Groner II on 11/30/23.
//

import Foundation
import SwiftData

@Model
class CustomFunction: ObservableObject {
    var id = UUID()
    var name: String
    var components: [Component] {
        willSet {
            objectWillChange.send()
        }
    }
    
    init(name: String, components: [Component]) {
        self.name = name
        self.components = components
    }
}

struct Component: Codable, Hashable {
    let op: Operation
    let dice: [Dice]
}

enum Operation: Codable {
    case add, subtract, multiply, divide
    
    var toString: String {
        switch self {
        case .add: return "plus"
        case .subtract: return "minus"
        case .multiply: return "multiply"
        case .divide: return "divide"
        }
    }
}

func castCustomFunction(_ components: [Component]) -> Double {
    components.reduce(0) { acc, cur in
        let result = cur.dice.reduce(UInt(0)) { a, die in
            return a + castDie(die)
        }
        
        switch cur.op {
        case .add: return acc + floor(Double(result))
        case .subtract: return acc - floor(Double(result))
        case .multiply: return acc * floor(Double(result))
        case .divide: return acc / floor(Double(result))
        }
    }
}
