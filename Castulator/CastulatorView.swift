//
//  CastulatorView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 12/8/23.
//

import SwiftUI

struct CastulatorView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var running: RunningCastulations = RunningCastulations()
    
    private func handleDiceButtonPress(_ die: Dice) {
        // if we have a castulation result already, begin a new castulation
        if running.rhs.result != nil {
            running = RunningCastulations(value: running.value + [Castulation()])
            return
        }
        
        // otherwise, append the indicated die to the current castulation
        // but only if there are less than 6
        if running.rhs.terms.count < 6 {
            let castulation = Castulation(
                operation: running.rhs.operation,
                terms: running.rhs.terms + [TermItem(die: die, roll: nil)]
            )
            
            running = RunningCastulations(value: running.value.map { $0 == running.rhs ? castulation : $0 })
        }
    }
    
    private func handleOpButtonPress(_ op: Operation) {
        
        // ignore repeat press
        if running.rhs.operation == op && running.rhs.result == nil { return }
        
        // ignore if only one castulation and zero dice
        if running.rhs.operation != op && running.rhs.terms.isEmpty && running.value.count == 1 { return }
        
        // switch op of current castulation if no result yet and zero dice
        if running.rhs.operation != op && running.rhs.terms.isEmpty && running.value.count > 1 {
            let castulation = Castulation(
                operation: op
            )
            
            running = RunningCastulations(value: running.value.map { $0 == running.rhs ? castulation : $0 })
            return
        }
        
        // append a new castulation if we have a result for the current castulation
        if !running.rhs.terms.isEmpty && running.rhs.result != nil {
            running = RunningCastulations(value: running.value + [Castulation(operation: op)])
            return
        }
        
        // otherwise, get result for current castulation and then append new castulation
        let castulation = Castulation(
            operation: running.rhs.operation,
            terms: running.rhs.terms.map { item in
                TermItem(die: item.die, roll: castDie(item.die))
            }
        )
        
        running = RunningCastulations(value: running.value.map { $0 == running.rhs ? castulation : $0 } + [Castulation(operation: op)])
    }
    
    private func handleEqualsButtonPress() {
        // ignore if nothing to work with
        if running.value.count == 1 && running.rhs.terms.isEmpty { return }
        
        // if there are some dice to work with in a single present castulation,
        // roll them if they haven't been rolled yet
        let castulation = Castulation(
            operation: running.rhs.operation,
            terms: running.rhs.terms.map { item in
                TermItem(die: item.die, roll: castDie(item.die))
            }
        )
        
        if running.rhs.result != nil {
            running = RunningCastulations(value: running.value + [castulation])
            return
        }
        
        running = RunningCastulations(value: running.value.map { $0 == running.rhs ? castulation : $0 })
    }
    
    private func handleClearButtonPress() {
        running = RunningCastulations()
    }
    
    private func handleRerollSingleButtonPress(term: TermItem, side: Castulation) {
        // ignore if nothing to reroll
        
        let castulation = Castulation(
            operation: side.operation,
            terms: side.terms.map { item in
                if term == item {
                    return TermItem(die: item.die, roll: castDie(item.die))
                }
                return item
            }
        )
        
        running = RunningCastulations(value: running.value.map { $0 == side ? castulation : $0 } )
    }
    
    private func handleRerollLastButtonPress() {
        // ignore if nothing to reroll
        if running.value.count == 1 && running.rhs.result == nil {
            return
        }
        
        let castulation = Castulation(
            operation: running.rhs.operation,
            terms: running.rhs.terms.map { item in
                TermItem(die: item.die, roll: castDie(item.die))
            }
        )
        
        running = RunningCastulations(value: running.value.map { $0 == running.rhs ? castulation : $0 } )
    }
    
    private func handleRerollAllButtonPress() {
        running = RunningCastulations(value: running.value.map { castulation in
            Castulation(operation: castulation.operation, terms: castulation.terms.map { item in
                TermItem(die: item.die, roll: castDie(item.die))
            })
        })
    }
    
    private func removeLastTerm() {
        let side = running.rhs.terms.count == 0 && running.value.count <= 2 ? running.lhs : running.rhs
        running = RunningCastulations(value: running.value.map { $0 == side ? Castulation(operation: $0.operation, terms: $0.terms.dropLast()) : $0} )
    }
    
    var body: some View {
        NavigationStack {
                ZStack {
                    VStack {
                        if running.lhs.result != nil && running.value.count > 2 {
                            HStack{
                                Spacer()
                                if running.total == Double.infinity || running.total > Double(Int.max) || running.total < Double(Int.min) {
                                    Text("\(running.total < Double(Int.min) ? "-" : "")Infinity")
                                        .font(Font.custom("MedievalSharp", size: 36)).frame(minHeight:24, maxHeight: 64).padding(.vertical, -12)
                                } else {
                                    Text(String(Int(running.total)))
                                        .font(Font.custom("MedievalSharp", size: 36)).frame(minHeight:24, maxHeight: 64).padding(.vertical, -12)
                                }
                            }
                            .padding(.bottom, 12)
                        } else {
                            if running.value.count == 1 {
                                HStack {
                                    if running.rhs.result != nil {
                                        Image(systemName: Operation.add.toString)
                                    }
                                    Spacer()
                                    ForEach(running.rhs.terms) { term in
                                        Button {
                                            handleRerollSingleButtonPress(term: term, side: running.rhs)
                                        }
                                    label: {
                                        ZStack{
                                            DynamicImage(term.die.rawValue)
                                                .frame(minHeight: 24, maxHeight: 64)
                                                .padding(term.die.rawValue == "d12" ? -6 : -12)
                                                .opacity(term.roll != nil ? 0.3 : 1)
                                            if term.roll != nil {
                                                Text(String(Int(term.roll!)))
                                                    .font(Font.custom("MedievalSharp", size: 24))
                                            }
                                        }
                                    }
                                        if term != running.rhs.terms.last {
                                            Image(systemName: Operation.add.toString).resizable().frame(width: 6, height: 6)
                                        }
                                    }
                                }
                                .padding(.bottom, 12)
                            } else {
                                HStack {
                                    Spacer()
                                    ForEach(running.lhs.terms) { term in
                                        Button {
                                            handleRerollSingleButtonPress(term: term, side: running.lhs)
                                        }
                                    label: {
                                        ZStack{
                                            DynamicImage(term.die.rawValue)
                                                .frame(minHeight: 24, maxHeight: 64)
                                                .padding(term.die.rawValue == "d12" ? -6 : -12)
                                                .opacity(term.roll != nil ? 0.3 : 1)
                                            if term.roll != nil {
                                                Text(String(Int(term.roll!)))
                                                    .font(Font.custom("MedievalSharp", size: 24))
                                            }
                                        }
                                    }
                                        if term != running.lhs.terms.last {
                                            Image(systemName: Operation.add.toString).resizable().frame(width: 6, height: 6)
                                        }
                                    }
                                }
                                .padding(.bottom, 12)
                            }
                        }
                        
                        
                        VStack {
                            if running.value.count > 1 {
                                HStack {
                                    Image(systemName: running.rhs.operation.toString)
                                    Spacer()
                                    ForEach(running.rhs.terms) { term in
                                        Button {
                                            handleRerollSingleButtonPress(term: term, side: running.rhs)
                                        }
                                        label: {
                                            ZStack{
                                                DynamicImage(term.die.rawValue)
                                                    .frame(minHeight: 24, maxHeight: 64)
                                                    .padding(term.die.rawValue == "d12" ? -6 : -12)
                                                    .opacity(term.roll != nil ? 0.3 : 1)
                                                if term.roll != nil {
                                                    Text(String(Int(term.roll!)))
                                                        .font(Font.custom("MedievalSharp", size: 24))
                                                }
                                            }
                                        }
                                        if term != running.rhs.terms.last {
                                            Image(systemName: Operation.add.toString).resizable().frame(width: 6, height: 6)
                                        }
                                    }
                                    
                                }.frame(minHeight: 24, maxHeight: 64).padding(.top, -6)
                            }
                        }
                        
                        if running.rhs.result != nil {
                            let runningTotal = Castulation.castulate(lhsTerm: running.total, op: running.rhs.operation, rhsTerm: Double(running.rhs.result!))
                            Divider()
                            HStack {
                                Spacer()
                                if runningTotal == Double.infinity || runningTotal > Double(Int.max) || runningTotal < Double(Int.min) {
                                    Text("\(running.total < Double(Int.min) ? "-" : "")Infinity").font(Font.custom("MedievalSharp", size: 42))
                                } else {
                                    Text(String(Int(runningTotal)))
                                        .font(Font.custom("MedievalSharp", size: 42))
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    
                    VStack {
                        Spacer()
                        
                        DicePadView(
                            onDiceButtonPress: handleDiceButtonPress,
                            onOpButtonPress: handleOpButtonPress,
                            onEqualsButtonPress: handleEqualsButtonPress,
                            onClearButtonPress: handleClearButtonPress,
                            onRerollLastButtonPress: handleRerollLastButtonPress,
                            onRerollAllButtonPress: handleRerollAllButtonPress
                        )
                    }
                }
                .padding()
                .background(Image(colorScheme == .dark ? "parchment-dark" : "parchment-light").resizable().scaledToFill().ignoresSafeArea(.all).opacity(0.6))
                .gesture(
                    DragGesture(minimumDistance: 20, coordinateSpace: .global)
                        .onEnded { value in
                            if value.translation.width < 0 || value.translation.width > 0 {
                                removeLastTerm()
                            }
                        }
                )
        }
        .tabItem {
            Label("Castulator", systemImage: "scroll.fill")
        }
    }
}

struct DynamicImage: View {
    @Environment(\.colorScheme) private var colorScheme
    let image: String
    init(_ image: String) {
        self.image = image
    }
    
    var body: some View {
        if colorScheme == .dark {
            Image(image).resizable().scaledToFit().colorInvert()
        } else {
            Image(image).resizable().scaledToFit()
        }
    }
}

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
                    DynamicImage("d20").padding(-18)
                }.padding()
                
                Button {
                    onDiceButtonPress(.d100)
                } label: {
                    DynamicImage("d100").padding(-24)
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
                }.padding()
                
                Button {
                    onDiceButtonPress(.d12)
                } label: {
                    DynamicImage("d12").padding(-16)
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
                }.padding()
                
                Button {
                    onDiceButtonPress(.d8)
                } label: {
                    DynamicImage("d8").padding(-18)
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
                }.padding()
                
                Button {
                    onDiceButtonPress(.d4)
                } label: {
                    DynamicImage("d4").padding(-18)
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

struct TermItem: Equatable, Hashable, Identifiable {
    let id = UUID()
    let die: Dice
    let roll: UInt?
}

struct Castulation: Identifiable, Equatable {
    let id = UUID()
    let operation: Operation
    let terms: [TermItem]
    
    var result: UInt? {
        let rolls = self.terms.compactMap { $0.roll }
        
        return rolls.count > 0
            ? rolls.reduce(0) { $0 + $1 }
            : nil
    }
    
    static func castulate(lhsTerm: Double, op: Operation, rhsTerm: Double) -> Double {
        switch op {
        case .add: floor(lhsTerm + rhsTerm)
        case .subtract: floor(lhsTerm - rhsTerm)
        case .multiply: floor(lhsTerm * rhsTerm)
        case .divide: floor(lhsTerm / (rhsTerm == 0 ? 1 : rhsTerm))
        }
    }
    
    init(operation: Operation = .add, terms: [TermItem] = []) {
        self.operation = operation
        self.terms = terms
    }
    
    static func == (lhs: Castulation, rhs: Castulation) -> Bool {
        lhs.id == rhs.id
    }
}

struct RunningCastulations {
    let value: [Castulation]
    
    var rhs: Castulation {
        value.last ?? Castulation()
    }
    
    var lhs: Castulation {
        value.count <= 1
            ? Castulation()
            : value[value.count - 2]
    }
    
    var total: Double {
        value.reduce(0) { total, castulation in
            if castulation == value[value.count - 1] {
                return total
            }
            
            if castulation.result != nil {
                return Castulation.castulate(lhsTerm: total, op: castulation.operation, rhsTerm: Double(castulation.result!))
            }
            
            return total
        }
    }
    
    init(value: [Castulation] = [Castulation()]) {
        self.value = value
    }
}
