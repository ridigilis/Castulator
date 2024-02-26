//
//  CastResultHistoryView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 11/29/23.
//

import SwiftUI

struct QuickCastResultHistoryView: View {
    let result: QuickCastResult
    
    let dateFormatter = RelativeDateTimeFormatter()
    
    var body: some View {
        HStack {
            Text(result.die.rawValue)
                .font(Font.custom("MedievalSharp", size: 18))
                .dynamicTypeSize(.large)
                .background {
                    Capsule().colorInvert().padding(-4).opacity(0.6)
                }.opacity(0.75)
            DynamicImage(result.die.rawValue)
                .opacity(0.2)
                .overlay {
                    Text(String(result.value))
                        .opacity(0.8)
                        .font(
                            Font.custom("MedievalSharp", size: 24)
                        )
                }
            Spacer()
            Text("\(dateFormatter.localizedString(fromTimeInterval: result.castDate.timeIntervalSinceNow))")
        }
        .frame(alignment: .center)
        .background(Color.clear)
    }
}
