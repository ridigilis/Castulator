//
//  CastResultView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 11/29/23.
//

import SwiftUI

struct QuickCastResultView: View {
    let result: QuickCastResult
    
    var body: some View {
        ZStack {
            Image(result.die.rawValue)
                .resizable()
                .scaledToFit()
                .opacity(0.30)
            Text(String(result.value))
                .font(
                    Font.custom("MedievalSharp", size: 48)
                )
        }.padding()
    }
}
