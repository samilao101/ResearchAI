//
//  ForwardButton.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/18/23.
//

import SwiftUI

struct ForwardButton: View {
    var body: some View {
        Image(systemName: "arrow.down.message.fill")
            .foregroundStyle(
                .blue.gradient.shadow(
                    .inner(color: .black, radius: 10, x: 50, y:  50)
                )
                .shadow(
                    .drop(color: .black.opacity(0.2), radius: 10, x:   50, y:  50)
                )
            )
            .font(.system(size: 600).bold())
            
            
    }
}

struct ForwardButton_Previews: PreviewProvider {
    static var previews: some View {
        ForwardButton()
    }
}
