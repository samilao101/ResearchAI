//
//  PaperModel.swift
//  ResearchAI
//
//  Created by Sam Santos on 1/14/23.
//

import Foundation
import PDFKit

struct PaperModel: Identifiable {
    
    var id: UUID {paper.id}
    
    let paper: DecodedPaper
    
    let pdf: PDFDocument
    
    let reading: ReadingEntity
    
    
}

struct DecodedPaper: Codable, Identifiable {
    
    var id = UUID()
    let title: String
    let sections: [Section]
    
    struct Section: Codable, Identifiable {
        var id = UUID()
        let head: String
        let paragraph: [String]
    }
    
}


protocol ResearchPaperProtocol {
    
    var title: String { get }
    var authors: [String] { get  }
    var summary: String { get  }
    var url: URL { get  }
    
}
