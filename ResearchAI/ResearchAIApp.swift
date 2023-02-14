//
//  ResearchAIApp.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/28/22.
//

import SwiftUI

@main
struct ResearchAIApp: App {
    
    @State var selectingDatabase = true
    var settingsModel = SettingsModel.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ZStack{
                    ResearchPaperListView()
                        .navigationTitle("Research Papers:")
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



