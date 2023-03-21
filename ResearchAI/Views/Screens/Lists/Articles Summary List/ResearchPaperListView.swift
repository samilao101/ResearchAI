//
//  ContentView.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/28/22.
//

import SwiftUI

struct ResearchPaperListView: View {
    
    @EnvironmentObject var appState : AppState 
    @StateObject var urlModel = SettingsModel.shared
    @State var textWriten = ""
    let comprehensions: [Comprehension]?
    
    var body: some View {
        
        VStack {
            HStack {
                TextField("Type here...", text: $textWriten)
                    .textViewModifier()
                Button("Send"){send(string: textWriten)}
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            if appState.noResults {
                Text("No Results...")
                Spacer()
            } else {
                List(appState.summaries) { summary in
                    NavigationLink(value: summary) {
                        ArticleRowView(title: summary.raiTitle, authors: summary.raiAuthors, tags: summary.raitags)
                    }
                }
            }
        }
        .navigationTitle("Research Papers:")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Toggle("online", isOn: $urlModel.online)
                    .toggleStyle(.button)
                    .tint(.green)
            }
            if appState.savedComprehesions != nil {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SavedPaperAlbumView()
                            .environmentObject(appState)
                    } label: {
                        HStack{
                            Image(systemName: "newspaper")
                            Text("Saved Papers")
                        }
                    }

                }
            }
        }
        
    }
    func send(string: String) {
        Task { await appState.query(string)}
    }
}

//TODO
//struct ResearchPaperListView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        NavigationView {
//            ResearchPaperListView()
//        }
//    }
//
//}



