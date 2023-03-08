//
//  DatabaseCardView.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/3/23.
//

import SwiftUI

struct DatabaseCardView: View {
    
    let title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding(.top, 10)
        }
        .frame(width: 150, height: 75)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}


struct DatabaseCardView_Previews: PreviewProvider {
    static var previews: some View {
        DatabaseCardView(title: "Arxiv")
    }
}
