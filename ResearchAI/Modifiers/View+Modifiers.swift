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


struct ThinBackGround: ViewModifier {
    
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .background(Color.theme.accent)
        
    }
    
    
}

extension View {
    func thinBackGround() -> some View {
        self
            .modifier(ThinBackGround())
    }
}

struct StrokeStyle: ViewModifier {
    
    var cornerRadius: CGFloat
    
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(.linearGradient(colors: [.white.opacity(colorScheme == .dark ? 0.6 : 0.3), .black.opacity(colorScheme == .dark ? 0.3 : 0.1)], startPoint: .top, endPoint: .bottom))
                    .blendMode(.overlay)
            )
        
    }
    
    
}

extension View {
    func strokeStyle(cornerRadius: CGFloat = 30.0) -> some View {
        self
        .modifier(StrokeStyle(cornerRadius: cornerRadius))
    }
}


