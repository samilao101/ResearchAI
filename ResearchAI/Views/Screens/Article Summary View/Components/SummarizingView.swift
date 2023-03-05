//
//  SummarizingView.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/3/23.
//

import SwiftUI

struct SummarizingView: View {
    
    let isSummarizing: Bool
    let simplifiedSummary: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Simplified Summary:")
                .bold()
            if isSummarizing {
                ProgressView()
            } else {
                Text(simplifiedSummary)
            }
        }
        .summaryModifier(simplified: simplifiedSummary.isEmpty)
    }
}

struct SummarizingView_Previews: PreviewProvider {
    static var previews: some View {
        SummarizingView(isSummarizing: true, simplifiedSummary: "This is simplificationg of the text provided in the summary.")
    }
}
