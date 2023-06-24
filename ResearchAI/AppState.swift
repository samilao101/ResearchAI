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
    
    static let shared = AppState(servicer: ArxivPaperServicer())
    let comprehensionLocalFileManager = LocalFileManager<Comprehension>(folder: .comprehensions , model: Comprehension.self )
    
    init(servicer: PaperServicerProtocol ) {
        paperSearchServicer = servicer
        getSavedAllComprehensions()
    }
    
    @Published var paperSearchServicer: PaperServicerProtocol
    
    @Published var summaries: [RAISummary] = []
    
    @Published var savedComprehesions : [Comprehension]? = nil
    
    var comprehensionStored: [Comprehension] {
        return savedComprehesions?.compactMap({$0}) ?? []
    }
    
    var comprehension = Comprehension(summary: nil, pdfData: nil, decodedPaper: nil) {
        didSet {
            print("seeing if decoded is not nil")
            if comprehension.decodedPaper != nil {
                print("decoded is not ni")
            }
        }
    }
    
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
    
    func addSummaryToComprehension(summary: RAISummary) {
        comprehension.summary = summary

    }
    
    func addPDFDataToComprehension(pdfData: Data ) {
        comprehension.pdfData = pdfData
    }
    
    func addDecodedPaperToComprehension(decodedPaper: ParsedPaper) {
        comprehension.decodedPaper = decodedPaper
     
    }
    
    func clearComprehension() {
        self.comprehension = Comprehension(summary: nil, pdfData: nil, decodedPaper: nil)
    }
    
    func removeComprehensionFromStorage(id: String) {
        comprehensionLocalFileManager.deleteModel(id: id)
        getSavedAllComprehensions()
    }

    
}
