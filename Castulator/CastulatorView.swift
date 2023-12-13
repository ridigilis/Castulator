//
//  CastulatorView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 12/8/23.
//

import SwiftUI

struct CastulatorView: View {
    @State private var components: [Component] = [Component(op: .add, dice: [])]
    @State private var result: Double?
    @State private var prevResult: Double?
    
    func opString(_ op: Operation) -> String {
        switch op {
        case .add: return "plus"
        case .subtract: return "minus"
        case .multiply: return "multiply"
        case .divide: return "divide"
        }
    }
    
    func changeWorkingComponents(op: Operation?, die: Dice?) {
        if op != nil {
            switch op {
            case .add: components.append(Component(op: .add, dice: []))
            case .subtract: components.append(Component(op: .subtract, dice: []))
            case .multiply: components.append(Component(op: .multiply, dice: []))
            case .divide: components.append(Component(op: .divide, dice: []))
            case .none: return // should never be reached
            }
        }
        
        func appendDie(_ die: Dice) {
            components = components.map { comp in
                if comp == components.last {
                    var newDice = comp.dice
                    newDice.append(die)
                    return Component(op: comp.op, dice: newDice)
                }
                return comp
            }
        }
        
        if die != nil {
            switch die {
            case .d2: appendDie(.d2)
            case .d4: appendDie(.d4)
            case .d6: appendDie(.d6)
            case .d8: appendDie(.d8)
            case .d10: appendDie(.d10)
            case .d12: appendDie(.d12)
            case .d20: appendDie(.d20)
            case .d100: appendDie(.d100)
            case .none: return // should never be reached
            }
        }
    }
    
    var body: some View {
        NavigationStack {
                ZStack {
                    VStack {
                        ForEach(Array(components.enumerated()), id: \.self.offset) { idx, component in
                            HStack {
                                if idx != 0 || (idx == 0 && component.op != .add) {
                                    Image(systemName: opString(component.op))
                                }
                                Spacer()
                                ForEach(component.dice, id: \.self) { die in
                                    Image(die.rawValue).resizable().scaledToFit().frame(minHeight: 24, maxHeight: 48)
                                }
                            }
                            
                            if idx != 0 || (idx == 0 && component.op != .add) {
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
                            onButtonPress: changeWorkingComponents,
                            components: $components,
                            result: $result,
                            prevResult: $prevResult
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
    var onButtonPress: (Operation?, Dice?) -> Void
    @Binding var components: [Component]
    @Binding var result: Double?
    @Binding var prevResult: Double?
    
    var body: some View {
        Grid {
            GridRow {
                Button {
                    onButtonPress(nil, .d20)
                } label: {
                    Image("d20").resizable().scaledToFit()
                }.padding()
                
                Button {
                    onButtonPress(nil, .d100)
                } label: {
                    Image("d100").resizable().scaledToFit()
                }.padding()
                
                Button {
                    onButtonPress(.divide, nil)
                } label: {
                    Image("divide").resizable().scaledToFit()
                }.padding()
            }
            
            GridRow {
                Button {
                    onButtonPress(nil, .d10)
                } label: {
                    Image("d10").resizable().scaledToFit()
                }.padding()
                
                Button {
                    onButtonPress(nil, .d12)
                } label: {
                    Image("d12").resizable().scaledToFit()
                }.padding()
                
                Button {
                    onButtonPress(.multiply, nil)
                } label: {
                    Image("multiply").resizable().scaledToFit()
                }.padding()
            }
            
            GridRow {
                Button {
                    onButtonPress(nil, .d6)
                } label: {
                    Image("d6").resizable().scaledToFit()
                }.padding()
                
                Button {
                    onButtonPress(nil, .d8)
                } label: {
                    Image("d8").resizable().scaledToFit()
                }.padding()
                
                Button {
                    onButtonPress(.subtract, nil)
                } label: {
                    Image("minus").resizable().scaledToFit()
                }.padding()
                
                Button {
                    result = nil
                    prevResult = nil
                    components = [Component(op: .add, dice: [])]
                } label: {
                    Label("AC", systemImage: "")
                }.padding()
            }
            
            GridRow {
                Button {
                    onButtonPress(nil, .d2)
                } label: {
                    Image("d2").resizable().scaledToFit()
                }.padding()
                
                Button {
                    onButtonPress(nil, .d4)
                } label: {
                    Image("d4").resizable().scaledToFit()
                }.padding()
                
                Button {
                    onButtonPress(.add, nil)
                } label: {
                    Image("plus").resizable().scaledToFit()
                }.padding()
                
                Button {
                    result = castCustomFunction(components)
                } label: {
                    Image("equals").resizable().scaledToFit()
                }.padding()
            }
        }
    }
}
