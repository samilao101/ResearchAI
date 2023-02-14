//
//  DatabaseViewer.swift
//  ResearchAI
//
//  Created by Sam Santos on 2/7/23.
//

import SwiftUI

struct Card: View {
    
    let title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding(.top, 10)
        }
        .frame(width: 200, height: 75)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct DatabaseViewer: View {
    
    @ObservedObject var appState = AppState.shared
    @Binding var selectingDatabase: Bool
    @State var databases: [RAIPaperDatabase] = [
        
        RAIPaperDatabase(model: ArxivResearchPaperEntry.self,
                         url: Constant.URLstring.ArxivSearch,
                       name: "ARXIV")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(0 ..< 1) { _ in
                    HStack(spacing: 20) {
                        ForEach(databases) { database in
                            Card(title: database.name).onTapGesture {
                                appState.selectedDatabase = database
                                selectingDatabase.toggle()
                            }
                        }
                    }
                }
            }.padding()
        }.padding()
    }
}
