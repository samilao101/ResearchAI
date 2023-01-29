//
//  ResearchPaper.swift
//  ResearchAI
//
//  Created by Sam Santos on 1/25/23.
//

import Foundation


protocol ResearchPaperProtocol {
    
    var title: String { get }
    var authors: [String] { get  }
    var summary: String { get  }
    var url: URL { get  }
    
}


struct ResearchPaperMetaData {
    
    
    let source: ResearchPaperProtocol
    
    var title: String { source.title }
    
    var authors: [String] { source.authors }
    
    var summary: String { source.summary }
    
    var url: URL { source.url }
    
    
}
