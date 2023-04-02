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
    
    func summaryModifier(simplified: Bool) -> some View {
        self
            .padding()
            .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous).stroke(.gray, lineWidth: 1.0))
            .padding()
            .foregroundColor(simplified ? .blue : .black)
    }
    
    func buttonModifier(color: Color) -> some View {
        self
            .padding()
            .background(color)
            .cornerRadius(8)
            .foregroundColor(.white)
            .padding(.top, 34)
    }
    
    func buttonModifierChangedPadding(color: Color, lPad: Double, rPad: Double, tPad: Double, bPad: Double ) -> some View {
        self
            .padding()
            .background(color)
            .cornerRadius(8)
            .foregroundColor(.white)
            .padding(.leading, lPad )
            .padding(.trailing, rPad )
            .padding(.top, tPad )
            .padding(.bottom, bPad )
    }
    
    
    func buttonModifierNoPadding(color: Color) -> some View {
        self
            .padding()
            .background(color)
            .cornerRadius(8)
            .foregroundColor(.white)
    }
    
}


