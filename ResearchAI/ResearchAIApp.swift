//
//  ResearchAIApp.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/28/22.
//

import SwiftUI

@main
struct ResearchAIApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView{
            ResearchPaperListView(model: ArxivQueryService())
                    .navigationTitle("Research Papers:")
            }
            .environment(\.colorScheme, .light)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
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



