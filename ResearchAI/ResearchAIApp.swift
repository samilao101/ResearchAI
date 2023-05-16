//
//  ResearchAIApp.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/28/22.
//

import SwiftUI

@main
struct ResearchAIApp: App {
    
    let ComprehensionLocalFileManager = LocalFileManager<Comprehension>(folder: .comprehensions , model: Comprehension.self )
    @ObservedObject var appState : AppState = AppState.shared
    @State var selectingDatabase = true
    var settingsModel = SettingsModel.shared

    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ZStack{
                    ResearchPaperListView(comprehensions: ComprehensionLocalFileManager.getAllModels())
                        .environmentObject(appState)

                    }
                .navigationDestination(for: RAISummary.self) { summary in
                        RAISummaryView(summary: summary)
                }
            }
            .environment(\.colorScheme, .light)
            .onAppear {
                settingsModel.setupAudioDefaults()
            }
          
            
        }
    }
}




