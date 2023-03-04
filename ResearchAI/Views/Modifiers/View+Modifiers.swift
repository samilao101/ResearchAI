//
//  View+Modifiers.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/3/23.
//

import SwiftUI

extension View {
    func textViewModifier() -> some View {
        self
            .padding(6.0)
            .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                          .stroke(.gray, lineWidth: 1.0))
            .padding()
    }
}
