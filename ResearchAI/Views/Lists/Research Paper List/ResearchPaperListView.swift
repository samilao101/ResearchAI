//
//  ContentView.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/28/22.
//

import SwiftUI

struct ResearchPaperListView: View {
    
    
    @StateObject var appState : AppState = AppState.shared
    @StateObject var urlModel = URLModel.shared
    @StateObject var storage = StorageManager()
    @ObservedObject var model: PaperSearchServicer
    @State var textWriten = ""

    var body: some View {
    
        VStack {
            HStack {
                TextField("Type here...", text: $textWriten)
                    .padding(6.0)
                    .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                  .stroke(.gray, lineWidth: 1.0))
                    .padding()
                    .onChange(of: textWriten) { newValue in
                        Task{
                            await appState.query(newValue)
                        }
                    }
                Button("Send"){
                    DispatchQueue.main.async {
                        send(string: textWriten)
                    }
                }
            }
            .foregroundColor(.black)
            .padding(.horizontal)
            if appState.noResults {
                Text("No Results...")
                Spacer()
            } else {
                List(appState.summaries) { summary in
                    NavigationLink(destination: RAISummaryView(summary: summary).environmentObject(storage)) {
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
         
        .onAppear {
            storage.load()
            appState.load()
            print(storage.listSavedPDFs())
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Toggle("online", isOn: $urlModel.online)
                    .toggleStyle(.button)
                    .tint(.green)
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink {
                    SavedPapersListView().environmentObject(storage)
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
//        model.search(query: string)
        Task {
            await appState.query(string)

        }
    }
    
   
}




