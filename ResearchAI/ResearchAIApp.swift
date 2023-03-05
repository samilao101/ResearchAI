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
    
    @State var selectingDatabase = true
    var settingsModel = SettingsModel.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ZStack{
                    ResearchPaperListView(comprehensions: ComprehensionLocalFileManager.getAllModels())
                        
                    DatabaseSelectionButton(selectingDatabase: $selectingDatabase)
                }
                .navigationDestination(for: RAISummary.self) { summary in
                    RAISummaryView(summary: summary)
                        .environmentObject(ComprehensionLocalFileManager)
                }
                .navigationDestination(for: [Comprehension].self) { comprehensions in
                    SavedPaperListView(listSavedPapers: comprehensions)
                }
            }
            .environment(\.colorScheme, .light)
            .onAppear {
                settingsModel.setupAudioDefaults()
            }.fullScreenCover(isPresented: $selectingDatabase) {
                DatabaseViewer(selectingDatabase: $selectingDatabase)
            }
            
        }
    }
}




