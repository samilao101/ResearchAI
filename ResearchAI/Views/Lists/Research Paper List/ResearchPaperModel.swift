//
//  ResearchPaperModel.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/28/22.
//

import Foundation
import XMLParsing

 

class ResearchPaperModel: ObservableObject {
    
    @Published var noResults = true
    
    @Published var researchPapers: [ResearchPaper] = []

    func search(query: String) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: "\(Constant.URLstring.ArxivSearch)\(encodedQuery)")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Parse the response data to create an array of ResearchPaper objects
            if let data = data {
                do {
                let feed = try XMLDecoder().decode(Feed.self, from: data)
                    DispatchQueue.main.async {
                        self.noResults = false
                    }
                    let papers = feed.entry.map { entry in
                        ResearchPaper(
                            title: entry.title,
                            authors: entry.author.map { author in
                                ResearchPaper.Author(name: author.name)
                            },
                            published: entry.published,
                            updated: entry.updated,
                            summary: entry.summary,
                            link: entry.link.map { link in
                                                        
                                ResearchPaper.Link(title: link.title ?? "", href: link.href, rel: link.rel, type: link.type ?? "")
                                                    }

                        )
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.researchPapers = papers
                    }
                } catch(let error) {
                    print(error)
                    DispatchQueue.main.async {
                        self.noResults = true
                    }
                }
              
             
            }
        }.resume()
    }
}
