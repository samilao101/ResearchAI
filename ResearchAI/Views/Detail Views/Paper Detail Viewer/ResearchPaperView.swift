//
//  ResearchPaperView.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/28/22.
//

import SwiftUI

struct ResearchPaperView: View {
    @EnvironmentObject var pdfManager: StorageManager
    @ObservedObject var viewModel = OpenAIServicer()
    var researchPaper: ArxivResearchPaperDetail
    @State var simplified: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack{
                Text(researchPaper.title)
                    .font(.title)
                Text(researchPaper.authors.map { $0.name }.joined(separator: ", "))
                    .font(.subheadline)
                }
                Text("Published:")
                Text(researchPaper.published)
                    .font(.caption)
                Text("Updated:")
                Text(researchPaper.updated)
                    .font(.caption)
                Text("Summary:")
                    .bold()
                Text(researchPaper.summary)
                    .font(.body)
                VStack {
                    Text("Simplified Summary:")
                        .bold()
                    Text(simplified)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                              .stroke(.gray, lineWidth: 1.0))
                .padding()
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        LinksView(paperName: researchPaper.title, link: researchPaper.link.first(where: { link in
                            link.type == "application/pdf"
                        })!).environmentObject(pdfManager)
                        }
                }
            }.onAppear {
                viewModel.setup()
                let prompt = "\(Constant.prompt.simplifyAndSummarize)\(researchPaper.summary). "
                viewModel.send(text: prompt) { response in
                    DispatchQueue.main.async {
                      simplified = response
                    }
                }
                print(researchPaper.link)
            }
            .padding()
        }.navigationTitle("Paper:")
    }
}
