//
//  ResearchAIApp.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/28/22.
//

import SwiftUI

@main
struct ResearchAIApp: App {
    
    @ObservedObject var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
            ResearchPaperListView(model: PaperSearchServicer())
                    .navigationTitle("Research Papers:")
            }
            .environment(\.colorScheme, .light)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                
                //Michael: try @AppStorage, try more unique names more closely related to what is related, change everlogged 
                if !UserDefaults.standard.bool(forKey: "everlogged") {

                    UserDefaults.standard.set(1.0, forKey: "rate")
                    UserDefaults.standard.set(1.0, forKey: "pitch")
                    UserDefaults.standard.set(1.0, forKey: "volume")

                    UserDefaults.standard.set(true, forKey: "everlogged")
                    print("Setting defaults audio settings...")
                }
            }

        }
    }
}



