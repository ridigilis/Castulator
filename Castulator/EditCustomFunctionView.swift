//
//  EditCustomFunctionView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 12/1/23.
//

import SwiftUI

struct DicePadView: View {
    var onButtonPress: (Operation?, Dice?) -> Void
    
    var body: some View {
        Grid {
            GridRow {
                Button {
                    onButtonPress(nil, .d2)
                } label: {
                    Image("d2").resizable().scaledToFit()
                }
                
                Button {
                    onButtonPress(nil, .d4)
                } label: {
                    Image("d4").resizable().scaledToFit()
                }
                    
                Button {
                    onButtonPress(nil, .d6)
                } label: {
                    Image("d6").resizable().scaledToFit()
                }
                
                Button {
                    onButtonPress(nil, .d8)
                } label: {
                    Image("d8").resizable().scaledToFit()
                }
                
                Button {
                    onButtonPress(.add, nil)
                } label: {
                    Image(systemName: "plus").resizable().scaledToFit().frame(maxWidth: 36, maxHeight: 36)
                }
                
                Button {
                    onButtonPress(.subtract, nil)
                } label: {
                    Image(systemName: "minus").resizable().scaledToFit().frame(maxWidth: 36, maxHeight: 36)
                }
            }
            
            GridRow {
                Button {
                    onButtonPress(nil, .d10)
                } label: {
                    Image("d10").resizable().scaledToFit()
                }
                
                Button {
                    onButtonPress(nil, .d12)
                } label: {
                    Image("d12").resizable().scaledToFit()
                }
                
                Button {
                    onButtonPress(nil, .d20)
                } label: {
                    Image("d20").resizable().scaledToFit()
                }
                
                Button {
                    onButtonPress(nil, .d100)
                } label: {
                    Image("d100").resizable().scaledToFit()
                }
                
                Button {
                    onButtonPress(.multiply, nil)
                } label: {
                    Image(systemName: "multiply").resizable().scaledToFit().frame(maxWidth: 36, maxHeight: 36)
                }
                
                Button {
                    onButtonPress(.divide, nil)
                } label: {
                    Image(systemName: "divide").resizable().scaledToFit().frame(maxWidth: 36, maxHeight: 36)
                }
            }
        }
    }
}

struct EditCustomFunctionView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State var customFunction: CustomFunction
    
    func changeWorkingComponents(op: Operation?, die: Dice?) {
        if op != nil {
            switch op {
            case .add: customFunction.components.append(Component(op: .add, dice: []))
            case .subtract: customFunction.components.append(Component(op: .subtract, dice: []))
            case .multiply: customFunction.components.append(Component(op: .multiply, dice: []))
            case .divide: customFunction.components.append(Component(op: .divide, dice: []))
            case .none: return // should never be reached
            }
        }
        
        func appendDie(_ die: Dice) {
            customFunction.components = customFunction.components.map { comp in
                if comp == customFunction.components.last {
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
    
    func saveCustomFunction() {
        modelContext.insert(customFunction)
        dismiss()
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Name")) {
                    TextField(text: $customFunction.name) {}
                }
                Section(header: Text("Function")) {
                    CustomFunctionMathView(components: customFunction.components)
                }
            }
                
            DicePadView(onButtonPress: changeWorkingComponents)
        }
        .scrollContentBackground(.hidden)
        .background { Image("parchment") }
        .toolbar {
            ToolbarItemGroup {
                Button("Cancel") {
                    dismiss()
                }
                Button("Save") {
                    saveCustomFunction()
                }.disabled(customFunction.components.count <= 1)
            }
        }
    }
}

struct CustomFunctionMathView: View {
    var components: [Component]
    
    func opString(_ op: Operation) -> String {
        switch op {
        case .add: return "plus"
        case .subtract: return "minus"
        case .multiply: return "multiply"
        case .divide: return "divide"
        }
    }
    
    var body: some View {
        VStack {
            ForEach(Array(components.enumerated()), id: \.self.offset) { idx, component in
                HStack {
                    if idx != 0 || (idx == 0 && component.op != .add) {
                        Image(systemName: opString(component.op)).frame(maxHeight: 12)
                    }
                    Spacer()
                    ForEach(component.dice, id: \.self) { die in
                        Image(die.rawValue).resizable().scaledToFit()
                    }
                }
                .frame(maxHeight: 24)
                
                if idx != 0 || (idx == 0 && component.op != .add) {
                    Divider()
                }
            }
        }
        .padding()
    }
    
}
