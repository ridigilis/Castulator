//
//  CastResultHistoryView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 11/29/23.
//

import SwiftUI

struct CastResultHistoryView: View {
    let result: CastResult
    
    let dateFormatter = RelativeDateTimeFormatter()
    
    var body: some View {
        HStack {
            Image(result.die.rawValue)
                .resizable()
                .scaledToFit()
                .opacity(0.5)
            Text(String(result.value))
                .opacity(0.6)
                .font(
                    Font.custom("MedievalSharp", size: 24)
                )
            Spacer()
            Text("\(dateFormatter.localizedString(fromTimeInterval: result.castDate.timeIntervalSinceNow))")
        }
        .frame(alignment: .center)
    }
}
