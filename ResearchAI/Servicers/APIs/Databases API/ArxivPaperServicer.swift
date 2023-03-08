//
//  ResearchPaperModel.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/28/22.
//

import Foundation
import XMLParsing

class ArxivPaperServicer: ObservableObject, PaperServicerProtocol {
    var name: String = "Arxiv"
        
    var model = ArxivResearchPaperEntry.self
    
    let url = Constant.URLstring.ArxivSearch
            
    func querySearch(query: String) async throws -> [RAISummary] {
        print("searching arxiv")
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: "\(url)\(encodedQuery)")!
    
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let feed = try XMLDecoder().decode(model, from: data)
        
        let paperSummaries = feed.entries.map({RAISummary(source: $0)})
        
        return paperSummaries
    }
}



//Michael: try removing 'RAI', change RAISummaryEntryProtocol to ResearchPaper
//RAISummaryProtocol PaperSummary

struct ArxivResearchPaperEntry: Codable, RAISummaryEntryProtocol {
   
    var entries: [RAISummaryProtocol] {
        return entry
    }
    
    let entry: [Entry]

    struct Entry: Codable, RAISummaryProtocol {
        var raiTitle: String {
            title
        }
        
        var raiAuthors: [String] {
            return author.map({$0.name})
        }
        
        var raiPublished: String {
            published
        }
        
        var raiUpdated: String {
            updated
        }
        
        var raiSummary: String {
            summary
        }
        
        var raiLink: String {
            return link.first(where: {$0.type == "application/pdf"})!.href
        }
        
        let title: String
        let author: [Author]
        let published: String
        let updated: String
        let summary: String
        let link: [Link]

        struct Link: Codable {
            let title: String?
            let href: String
            let rel: String
            let type: String?

            private enum CodingKeys: String, CodingKey {
                case title, href, rel, type
            }
        }
        struct Author: Codable {
            let name: String
        }

       

   
    }
}

