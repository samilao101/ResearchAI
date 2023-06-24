//
//  CoreAPIServicer.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/4/23.
//

import Foundation

class CoreAPIPaperServicer: ObservableObject, PaperServicerProtocol {
    
    var name: String = "Core API"
        
    var model = CoreResearchPaperEntry.self
    
    let url = Constant.URLstring.CoreAPIBaseURL
            
  
    
    func querySearch(query: String) async throws -> [RAISummary] {
        print("searching core api")
        let baseURL = URL(string: url)!
        let urlFragment = "search/outputs"
        
        let headers = ["Authorization": "Bearer " + Constant.keys.coreAPIkey]
        let query = ["q": query, "limit": Int(20)] as [String : Any]
            let jsonData = try! JSONSerialization.data(withJSONObject: query)
            let url =   baseURL.appendingPathComponent(urlFragment)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.allHTTPHeaderFields = headers
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let feed = try JSONDecoder().decode(model, from: data)
  
        let paperSummaries = feed.entries.map({RAISummary(source: $0)})
        
        return paperSummaries
    }
}


struct CoreResearchPaperEntry: Codable, RAISummaryEntryProtocol {


    var entries: [RAISummaryProtocol] {
        return entry.filter({!$0.disabled})
    }

    let entry: [SearchResultItem]
    
    
    enum CodingKeys: String, CodingKey {
            case entry = "results"
        }

    
    struct SearchResultItem: Codable, Identifiable, RAISummaryProtocol {
        
        var raiTitle: String {
                title
        }
        
        var raiAuthors: [String] {
            authors.map({$0.name})
        }
        
        var raiPublished: String {
            publishedDate?.formatted() ?? "No Date"
        }
        
        var raiUpdated: String {
            updatedDate?.formatted() ?? "No Date"
        }
        
        var raiSummary: String {
            abstract ?? "No Abstract"
        }
        
        var raiLink: String {
            links.first(where: {$0.type == "download"})?.url ?? "no url"
        }
        
        var raitags: [String] {
            tags?.filter({!$0.contains("conference")}).filter({$0.count < 15}) ?? [""]
        }
        
        let id: Int
        let title: String
        let abstract: String?
        let authors: [Author]
        let publishedDate: Date?
        let updatedDate: Date?
        let fulltextStatus: String?
        let tags: [String]?
        let links: [Link]
        let disabled: Bool
        

        enum CodingKeys: String, CodingKey {
            case id
            case title, abstract, authors
            case publishedDate = "published_date"
            case updatedDate = "updated_date"
            case fulltextStatus = "fulltext_status"
            case tags, links
            case disabled
        }

        struct Author: Codable, Identifiable {
            var id: String { name }
            let name: String
        }
        
        struct Link: Codable {
            let type: String
            let url: String
            
            private enum CodingKeys: String, CodingKey {
                case type, url
            }
        }
        
        
     
    }
   
    
}
