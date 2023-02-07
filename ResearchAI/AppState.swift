//
//  AppState.swift
//  ResearchAI
//
//  Created by Sam Santos on 2/1/23.
//

import Foundation
import SwiftUI
import Combine

//Make it in a singleton 

@MainActor
class AppState: ObservableObject {
    
    static let shared = AppState()
    
    private init() {
        
    }
    
    var paperSearchServicer = PaperSearchServicer()
    @StateObject var decoder = PaperDecoder()
    
    let openAIServicer = OpenAIServicer()
    let storageManager = StorageManager.shared
    
    @Published var summaries: [RAISummary] = []
    
    @Published var databases: [RAIPaperDatabase] = [
        
        RAIPaperDatabase(model: ArxivResearchPaperEntry.self,
                         url: Constant.URLstring.ArxivSearch,
                       name: "ARXIV")
    ]
    
    
    var cancellables = Set<AnyCancellable>()
    
    @Published var noResults = true

    func load() {
        
        paperSearchServicer.$summaries
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .receive(on: RunLoop.main)
            .sink { _ in
                
            } receiveValue: { papers in
                self.noResults = false
                self.summaries = papers
            }.store(in: &cancellables)
        //Michael: try to use the other sink. 
    }
    

    
    func query(_ query: String) async {
        
        do {
            let database = databases[0]
            try await paperSearchServicer.querySearch(query: query, model: database.model,
                                                     url: database.urlString)
        } catch(let error) {
            print(error)
        }
        
    }
    
 
    
    
    
}
