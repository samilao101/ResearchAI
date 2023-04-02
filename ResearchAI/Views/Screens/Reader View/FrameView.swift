//
//  FrameView.swift
//  ResearchAI
//
//  Created by Sam Santos on 4/2/23.
//

import SwiftUI

struct FrameView: View {
    var body: some View {
        ZStack {
            HStack {
                Rectangle()
                    .frame(width: 6)
                Spacer()
                Rectangle()
                    .frame(width: 6)
            }
            VStack{
                Rectangle()
                    .frame(height: 60)
                Spacer()
                Rectangle()
                    .frame(height: 60)
            }
           
        }
        .ignoresSafeArea()
        .foregroundColor(.black.opacity(0.7))
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView()
    }
}
