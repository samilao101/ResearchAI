//
//  DatabaseViewer.swift
//  ResearchAI
//
//  Created by Sam Santos on 2/7/23.
//

import SwiftUI


struct DatabaseViewer: View {
    
    @ObservedObject var appState = AppState.shared
    @Binding var selectingDatabase: Bool
    @State var databases: [Database] = [
        Database(name: "Arxiv", database: ArxivPaperServicer())
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(0 ..< 1) { _ in
                    HStack(spacing: 20) {
                        ForEach(databases) { database in
                            DatabaseCardView(title: database.name).onTapGesture {
                                appState.paperSearchServicer = database.database
                                selectingDatabase.toggle()
                            }
                        }
                    }
                }
            }.padding()
        }.padding()
    }
}


