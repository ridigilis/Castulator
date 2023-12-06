//
//  CustomFunctionListView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 12/6/23.
//

import SwiftUI
import SwiftData

struct CustomFunctionListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var customFunctions: [CustomFunction]
    
    func delete(at offsets: IndexSet) {
        
    }
    
    var body: some View {
        List {
            ForEach(customFunctions) { fn in
                NavigationLink(fn.name) {
                    EditCustomFunctionView(customFunction: fn)
                }
                .swipeActions {
                    Button {
                        modelContext.delete(fn)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }.tint(.red)
                }
            }
        }
        .frame(alignment: .center)
        .background(Color.clear)
        .toolbar {
            ToolbarItem {
                NavigationLink {
                    EditCustomFunctionView(
                        customFunction: CustomFunction(
                            name: "New Custom Function",
                            components: [Component(op: .add, dice: [])]
                        )
                    )
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        
        if customFunctions.isEmpty {
            Button("Create a custom function!") {}
        }
    }
}
