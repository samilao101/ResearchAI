//
//  BackwardButton.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/18/23.
//

import SwiftUI

struct BackwardButton: View {
    
    var action: () -> ()
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(" << ")
        })
            .buttonModifier(color: .yellow)
    }
}

struct BackwardButton_Previews: PreviewProvider {
    static var previews: some View {
        BackwardButton(action: {})
    }
}
