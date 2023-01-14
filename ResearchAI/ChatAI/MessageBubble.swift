//
//  MessageBubble.swift
//  SpeakGPT
//
//  Created by Sam Santos on 12/28/22.
//

import SwiftUI
enum Source {
    case human
    case bot
}

struct MessageBubble: View, Hashable {
    
    let text: String
    let source: Source
    
    var body: some View {
        if source == .human{
        HStack{
            Text(text)
                .padding(6.0)
                .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                              .stroke(.gray, lineWidth: 3.0))
                .padding()
            Spacer()
        }
        } else {
        HStack {
            Spacer()
            Text(text)
                .padding(6.0)
                .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                              .stroke(.green, lineWidth: 3.0))
                .padding()
            }
        }
        }
    }


struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(text: "This is a sample text", source: .human)
    }
}
