//
//  ParsedPaper.swift
//  ResearchAI
//
//  Created by Sam Santos on 2/1/23.
//

import Foundation

struct ParsedPaper: Codable, Identifiable {
    
    var id = UUID()
    let title: String
    let sections: [Section]
    var figures: [FIGURE]?
    
    struct Section: Codable, Identifiable {
        var id = UUID()
        let head: String
        let paragraph: [String]
        var figAndParagraph: [P]?
    }
    
    

    
}



