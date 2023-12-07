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
    
    var body: some View {
        VStack {
            if customFunctions.isEmpty {
                Text("No Cast Result History to show.").font(.subheadline).opacity(0.6)
                Text("Try casting some dice!").font(.subheadline).opacity(0.6)
            } else {
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
            }
        }
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
    }
}
