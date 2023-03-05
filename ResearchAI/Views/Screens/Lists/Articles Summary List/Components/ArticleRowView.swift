//
//  ArticleRowView.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/3/23.
//

import SwiftUI

struct ArticleRowView: View {
    
    let title: String
    let authors: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            Text(authors.map { $0 }.joined(separator: ", "))
                .font(.subheadline)
        }
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRowView(title: "Machine Learning Maniforlds", authors: ["Samil Cruz", "Paveli Cruz", "Pamela Cruz"])
    }
}
