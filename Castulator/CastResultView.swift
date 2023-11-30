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
            Image(result.die.rawValue)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 256, maxHeight: 256)
                .opacity(0.5)
            Text(String(result.value))
                .font(
                    Font.custom("MedievalSharp", size: 48)
                )
                .foregroundStyle(Color.white)
                .background(Circle().frame(width: 96, height: 96))
                .opacity(0.6)
        }
    }
}

#Preview {
    CastResultView(result: CastResult(.d20))
}
