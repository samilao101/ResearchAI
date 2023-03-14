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
    
    static let shared = AppState(servicer: CoreAPIPaperServicer())
    let comprehensionLocalFileManager = LocalFileManager<Comprehension>(folder: .comprehensions , model: Comprehension.self )
    
    init(servicer: PaperServicerProtocol ) {
        paperSearchServicer = servicer
        getSavedAllComprehensions()
    }
    
    @Published var paperSearchServicer: PaperServicerProtocol
    
    @Published var summaries: [RAISummary] = []
    
    @Published var savedComprehesions : [Comprehension]? = nil
    
    var comprehension = Comprehension(summary: nil, pdfData: nil, decodedPaper: nil)
    
    var noResults: Bool { summaries.isEmpty }
    
    func query(_ query: String) async {
        
        do {
            summaries = try await paperSearchServicer.querySearch(query: query)
        } catch(let error) {
            print(error)
        }
    }
    
    @StateObject var decoder = PaperDecoder()
    let openAIServicer = OpenAIServicer()
    
    func getSavedAllComprehensions() {
        let savedComps = comprehensionLocalFileManager.getAllModels()
        savedComprehesions = savedComps
        print("getting all")
    }
    
    
    
}
