//
//  CastulatorView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 12/8/23.
//

import SwiftUI

struct CastulatorView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var vm = ViewModel()

    var body: some View {
        NavigationStack {
                ZStack {
                    VStack {
                        if vm.running.lhs.result != nil && vm.running.value.count > 2 {
                            HStack{
                                Spacer()
                                if vm.running.total == Double.infinity || vm.running.total > Double(Int.max) || vm.running.total < Double(Int.min) {
                                    Text("\(vm.running.total < Double(Int.min) ? "-" : "")Infinity")
                                        .font(Font.custom("MedievalSharp", size: 36)).frame(minHeight:24, maxHeight: 64).padding(.vertical, -12)
                                } else {
                                    Text(String(Int(vm.running.total)))
                                        .font(Font.custom("MedievalSharp", size: 36)).frame(minHeight:24, maxHeight: 64).padding(.vertical, -12)
                                }
                            }
                            .padding(.bottom, 12)
                        } else {
                            if vm.running.value.count == 1 {
                                HStack {
                                    if vm.running.rhs.result != nil {
                                        Image(systemName: Operation.add.toString)
                                    }
                                    Spacer()
                                    ForEach(vm.running.rhs.terms) { term in
                                        Button {
                                            vm.handleRerollSingleButtonPress(term: term, side: vm.running.rhs)
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
                                        if term != vm.running.rhs.terms.last {
                                            Image(systemName: Operation.add.toString).resizable().frame(width: 6, height: 6)
                                        }
                                    }
                                }
                                .padding(.bottom, 12)
                            } else {
                                HStack {
                                    Spacer()
                                    ForEach(vm.running.lhs.terms) { term in
                                        Button {
                                            vm.handleRerollSingleButtonPress(term: term, side: vm.running.lhs)
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
                                        if term != vm.running.lhs.terms.last {
                                            Image(systemName: Operation.add.toString).resizable().frame(width: 6, height: 6)
                                        }
                                    }
                                }
                                .padding(.bottom, 12)
                            }
                        }
                        
                        
                        VStack {
                            if vm.running.value.count > 1 {
                                HStack {
                                    Image(systemName: vm.running.rhs.operation.toString)
                                    Spacer()
                                    ForEach(vm.running.rhs.terms) { term in
                                        Button {
                                            vm.handleRerollSingleButtonPress(term: term, side: vm.running.rhs)
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
                                        if term != vm.running.rhs.terms.last {
                                            Image(systemName: Operation.add.toString).resizable().frame(width: 6, height: 6)
                                        }
                                    }
                                    
                                }.frame(minHeight: 24, maxHeight: 64).padding(.top, -6)
                            }
                        }
                        
                        if vm.running.rhs.result != nil {
                            let runningTotal = Castulation.castulate(lhsTerm: vm.running.total, op: vm.running.rhs.operation, rhsTerm: Double(vm.running.rhs.result!))
                            Divider()
                            HStack {
                                Spacer()
                                if runningTotal == Double.infinity || runningTotal > Double(Int.max) || runningTotal < Double(Int.min) {
                                    Text("\(vm.running.total < Double(Int.min) ? "-" : "")Infinity").font(Font.custom("MedievalSharp", size: 42))
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
                            onDiceButtonPress: vm.handleDiceButtonPress,
                            onOpButtonPress: vm.handleOpButtonPress,
                            onEqualsButtonPress: vm.handleEqualsButtonPress,
                            onClearButtonPress: vm.handleClearButtonPress,
                            onRerollLastButtonPress: vm.handleRerollLastButtonPress,
                            onRerollAllButtonPress: vm.handleRerollAllButtonPress
                        )
                    }
                }
                .padding()
                .background(Image(colorScheme == .dark ? "parchment-dark" : "parchment-light").resizable().scaledToFill().ignoresSafeArea(.all).opacity(0.6))
                .gesture(
                    DragGesture(minimumDistance: 20, coordinateSpace: .global)
                        .onEnded { value in
                            if value.translation.width < 0 || value.translation.width > 0 {
                                vm.removeLastTerm()
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
