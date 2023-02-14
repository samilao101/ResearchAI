//
//  ResearchPaperModel.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/28/22.
//

import Foundation
import XMLParsing

 

class PaperSearchServicer: ObservableObject {
    
    @Published var noResults = true
    
    @Published var summaries: [RAISummary] = []
    
    func querySearch<T:RAISummaryEntryProtocol>(query: String, model: T.Type, url: String) async throws {
        
        let urlString = url
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: "\(urlString)\(encodedQuery)")!
    
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let feed = try XMLDecoder().decode(T.self, from: data)

        self.noResults = false
        
        let papers = feed.entries.map({RAISummary(source: $0)})
        
        summaries = papers
        
    }
}
