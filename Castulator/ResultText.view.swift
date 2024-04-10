//
//  ResultText.view.swift
//  Castulator
//
//  Created by Ricky David Groner II on 4/10/24.
//

import SwiftUI

struct ResultTextView: View {
    var text: String = ""
    
    var body: some View {
        Text(text)
            .modifier(AppFont(size: 42))
            .frame(minHeight:24, maxHeight: 64)
            .padding(.vertical, -12)
    }
}
