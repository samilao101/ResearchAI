//
//  ContentView.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/28/22.
//

import SwiftUI

struct ResearchPaperListView: View {
    
    @StateObject var pdfManager = PDFManager()
    @ObservedObject var model: ResearchPaperModel
    @State var textWriten = ""

    var body: some View {
        VStack {
            HStack {
                TextField("Type here...", text: $textWriten)
                    .padding(6.0)
                    .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                  .stroke(.gray, lineWidth: 1.0))
                    .padding()
                Button("Send"){
                    DispatchQueue.main.async {
                        send(string: textWriten)
                    }
                }
            }
            .foregroundColor(.black)
            .padding(.horizontal)
            if model.noResults {
                Text("No Results...")
                Spacer()
            } else {
                List(model.researchPapers) { researchPaper in
                    NavigationLink(destination: ResearchPaperView(researchPaper: researchPaper).environmentObject(pdfManager)) {
                        VStack(alignment: .leading) {
                            Text(researchPaper.title)
                                .font(.headline)
                            Text(researchPaper.authors.map { $0.name }.joined(separator: ", "))
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .onAppear {
            print(pdfManager.listSavedPDFs())
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink {
                    SavedPapersListView().environmentObject(pdfManager)
                } label: {
                    HStack{
                    Image(systemName: "newspaper")
                    Text("Saved Papers")
                    }
                }
        }
        }
        
    }
    
    func send(string: String) {
        model.search(query: string)
    }
}




