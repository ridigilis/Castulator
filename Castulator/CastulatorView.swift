//
//  CastulatorView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 12/8/23.
//

import SwiftUI

struct CastulatorView: View {
    @State private var components: [Component] = [Component(op: .add, dice: [])]
    @State private var prevResult: Double?
    @State private var result: Double?
    
    private func castulate(lhsTerm: Double, op: Operation, rhsTerm: Double) -> Double {
        switch op {
        case .add: floor(lhsTerm + rhsTerm)
        case .subtract: floor(lhsTerm - rhsTerm)
        case .multiply: floor(lhsTerm * rhsTerm)
        case .divide: floor(lhsTerm / (rhsTerm == 0 ? 1 : rhsTerm))
        }
    }
    
    private func getLhsTerm(prevResult: Double?, lhsComponent: Component) -> Double {
        if prevResult != nil {
            return prevResult!
        }
        
        return lhsComponent.dice.reduce(0, {$0 + Double(castDie($1))})
    }
    
    private func handleDiceButtonPress(_ die: Dice) {
        components = components.map { comp in
            if comp == components.last {
                var newDice = comp.dice
                newDice.append(die)
                return Component(op: comp.op, dice: newDice)
            }
            return comp
        }
    }
    
    private func handleOpButtonPress(_ op: Operation) {
        let currentOp = components.last?.op ?? .add
        let currentDice = components.last?.dice ?? []
        
        // repeat press
        if op == currentOp && currentDice.isEmpty { return }
        
        if components.count == 1 {
            components.append(Component(op: op, dice: []))
            return
        }
        
        let lhsComponent = components[components.count - 2]
        let rhsComponent = components.last ?? Component(op: .add, dice: [])
        
        if result != nil {
            prevResult = result
            components.append(Component(op: op, dice: []))
            result = nil
        } else {
            prevResult = castulate(
                lhsTerm: getLhsTerm(prevResult: prevResult, lhsComponent: lhsComponent),
                op: rhsComponent.op,
                rhsTerm: rhsComponent.dice.reduce(0, {$0 + Double(castDie($1))})
            )
            components.append(Component(op: op, dice: []))
        }
    }
    
    private func handleEqualsButtonPress() {
        let currentDice = components.last?.dice ?? []
        
        if currentDice.isEmpty { return }
        
        let lhsComponent = components[components.count - 2]
        let rhsComponent = components.last ?? Component(op: .add, dice: [])
        
        if components.count == 1 {
            result = rhsComponent.dice.reduce(0, {$0 + Double(castDie($1))})
        }
        
        result = castulate(
            lhsTerm: getLhsTerm(prevResult: prevResult, lhsComponent: lhsComponent),
            op: rhsComponent.op,
            rhsTerm: rhsComponent.dice.reduce(0, {$0 + Double(castDie($1))})
        )
    }
    
    private func handleClearButtonPress() {
        result = nil
        prevResult = nil
        components = [Component(op: .add, dice: [])]
    }
    
    var body: some View {
        NavigationStack {
                ZStack {
                    VStack {
                        HStack {
                            Spacer()
                            
                            if prevResult != nil {
                                Text(String(Int(prevResult!)))
                                    .font(Font.custom("MedievalSharp", size: 36)).frame(minHeight:24, maxHeight: 64)
                            } else {
                                if components.count == 1 {
                                    ForEach(components[0].dice, id: \.self) { die in
                                        Image(die.rawValue).resizable().scaledToFit().frame(minHeight: 24, maxHeight: 64)
                                    }
                                } else {
                                    ForEach(components[components.count - 2].dice, id: \.self) { die in
                                        Image(die.rawValue).resizable().scaledToFit().frame(minHeight: 24, maxHeight: 64)
                                    }
                                }
                                
                            }
                        }
                        
                        VStack {
                            if components.count > 1 {
                                HStack {
                                    Image(systemName: components.last!.op.toString)
                                    Spacer()
                                    ForEach(components.last!.dice, id: \.self) { die in
                                        Image(die.rawValue).resizable().scaledToFit().frame(minHeight: 24, maxHeight: 64)
                                    }
                                    
                                }.frame(minHeight: 24, maxHeight: 64)
                                Divider()
                            }
                        }
                        
                        
                        
                        if result != nil {
                            HStack {
                                Spacer()
                                Text(String(Int(result!)))
                                    .font(Font.custom("MedievalSharp", size: 42))
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
                            onClearButtonPress: handleClearButtonPress
                        )
                    }
                }
                .padding()
                .background(Image("parchment-light").resizable().scaledToFill().ignoresSafeArea(.all).opacity(0.6))
        }
        .tabItem {
            Label("Castulator", systemImage: "scroll.fill")
        }
    }
}

struct DicePadView: View {
    var onDiceButtonPress: (Dice) -> Void
    var onOpButtonPress: (Operation) -> Void
    var onEqualsButtonPress: () -> Void
    var onClearButtonPress: () -> Void
    
    var body: some View {
        Grid {
            GridRow {
                Button {
                    onDiceButtonPress(.d20)
                } label: {
                    Image("d20").resizable().scaledToFit()
                }.padding()
                
                Button {
                    onDiceButtonPress(.d100)
                } label: {
                    Image("d100").resizable().scaledToFit()
                }.padding()
                
                Button {
                    onOpButtonPress(.divide)
                } label: {
                    Image(Operation.divide.toString).resizable().scaledToFit()
                }.padding()
            }
            
            GridRow {
                Button {
                    onDiceButtonPress(.d10)
                } label: {
                    Image("d10").resizable().scaledToFit()
                }.padding()
                
                Button {
                    onDiceButtonPress(.d12)
                } label: {
                    Image("d12").resizable().scaledToFit()
                }.padding()
                
                Button {
                    onOpButtonPress(.multiply)
                } label: {
                    Image(Operation.multiply.toString).resizable().scaledToFit()
                }.padding()
            }
            
            GridRow {
                Button {
                    onDiceButtonPress(.d6)
                } label: {
                    Image("d6").resizable().scaledToFit()
                }.padding()
                
                Button {
                    onDiceButtonPress(.d8)
                } label: {
                    Image("d8").resizable().scaledToFit()
                }.padding()
                
                Button {
                    onOpButtonPress(.subtract)
                } label: {
                    Image(Operation.subtract.toString).resizable().scaledToFit()
                }.padding()
                
                Button {
                    onClearButtonPress()
                } label: {
                    Label("AC", systemImage: "")
                }.padding()
            }
            
            GridRow {
                Button {
                    onDiceButtonPress(.d2)
                } label: {
                    Image("d2").resizable().scaledToFit()
                }.padding()
                
                Button {
                    onDiceButtonPress(.d4)
                } label: {
                    Image("d4").resizable().scaledToFit()
                }.padding()
                
                Button {
                    onOpButtonPress(.add)
                } label: {
                    Image(Operation.add.toString).resizable().scaledToFit()
                }.padding()
                
                Button {
                    onEqualsButtonPress()
                } label: {
                    Image("equals").resizable().scaledToFit()
                }.padding()
            }
        }
    }
}
