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
                    ResearchPaperListView()
                        .navigationTitle("Research Papers:")
                    selectDatabaseButton
                }
                .navigationDestination(for: RAISummary.self) { summary in
                    RAISummaryView(summary: summary)
                        .environmentObject(ComprehensionLocalFileManager)
                }
            }
            .environment(\.colorScheme, .light)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                settingsModel.setupAudioDefaults()
            }.fullScreenCover(isPresented: $selectingDatabase) {
                DatabaseViewer(selectingDatabase: $selectingDatabase)
            }
            
        }
    }
}

extension ResearchAIApp {
    
    private var selectDatabaseButton: some View {
        VStack{
            Spacer()
            HStack{
                Button {
                    selectingDatabase.toggle()
                } label: {
                    Image(systemName: "server.rack")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    
                }
                .frame(width: 70, height: 70)
                .background(Color.white)
                .foregroundColor(.black)
                .clipShape(Circle())
                .shadow(radius: 10)
                .padding()
                Spacer()
                
            }
        }
    }
    
    
    
}



