//
//  ContentView.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/28/22.
//

import SwiftUI

struct ResearchPaperListView: View {
    
    @ObservedObject var appState : AppState = AppState.shared
    @StateObject var urlModel = SettingsModel.shared
    @State var textWriten = ""
    let ComprehensionLocalFileManager = LocalFileManager<Comprehension>(folder: .comprehensions , model: Comprehension.self )
    
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
                        VStack(alignment: .leading) {
                            Text(summary.raiTitle)
                                .font(.headline)
                            Text(summary.raiAuthors.map { $0 }.joined(separator: ", "))
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Toggle("online", isOn: $urlModel.online)
                    .toggleStyle(.button)
                    .tint(.green)
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                
                NavigationLink {
                    SavedPaperListContainerView()
                        .environmentObject(ComprehensionLocalFileManager)
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
        Task { await appState.query(string)}
    }
}

struct ResearchPaperListView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            ResearchPaperListView()
        }
    }
    
}



