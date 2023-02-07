//
//  RAISummaryView.swift
//  ResearchAI
//
//  Created by Sam Santos on 2/7/23.
//

import SwiftUI

struct RAISummaryView: View {
    
    @EnvironmentObject var pdfManager: StorageManager
    @ObservedObject var viewModel = OpenAIServicer()
    @State var simplified: String = ""
    
    let summary: RAISummary

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(summary.raiTitle)
                    .font(.headline)
           
                    Text("Authors: ")
                    Text(summary.raiAuthors.joined(separator: ", "))
                        .font(.subheadline)
                
            
                    Text("Published: ")
                    Text(summary.raiPublished)
                        .font(.subheadline)
                
     
                    Text("Last Updated: ")
                    Text(summary.raiUpdated)
                        .font(.subheadline)
                
              
                    Text("Summary:")
                    Text(summary.raiSummary)
                        .font(.subheadline)
                
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
                        LinksView(paperName: summary.raiTitle, link: summary.raiLink).environmentObject(pdfManager)
                        }
                }
                .onAppear {
                    viewModel.setup()
                    let prompt = "\(Constant.prompt.simplifyAndSummarize)\(summary.raiSummary). "
                    viewModel.send(text: prompt) { response in
                        DispatchQueue.main.async {
                          simplified = response
                        }
                    }
                }
                .navigationTitle("Paper:")
                
            }
        }
        .padding()
        
    }
}

//struct RAISummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        RAISummaryView(summary: <#RAISummary#>)
//    }
//}
