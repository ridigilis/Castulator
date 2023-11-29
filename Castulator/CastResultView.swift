//
//  CastResultView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 11/29/23.
//

import SwiftUI

struct CastResultView: View {
    let result: CastResult
    
    var body: some View {
        ZStack {
            Image(result.die.rawValue).resizable().scaledToFit().opacity(0.15)
            Text(String(result.value))
                .opacity(0.6)
                .font(
                    Font.custom("MedievalSharp", size: 84)
                )
        }
    }
}

#Preview {
    CastResultView(result: CastResult(.d20))
}
