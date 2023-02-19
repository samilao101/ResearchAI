import XMLParsing
import SwiftUI

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
            var authors : [String] = []
             author.map(({ author in
                authors.append(author.name)
            }))
            return authors
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
            let linked = link.first { link in
                link.type == "application/pdf"
            }
            return linked!.href
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

