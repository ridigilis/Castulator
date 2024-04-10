//
//  AppFont.viewmodifier.swift
//  Castulator
//
//  Created by Ricky David Groner II on 4/10/24.
//

import SwiftUI

struct AppFont: ViewModifier {
    var size: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .font(Font.custom("MedievalSharp", size: size))
    }
}
