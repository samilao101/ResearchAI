//
//  Protocols+Extensions.swift
//  ResearchAI
//
//  Created by Sam Santos on 2/26/23.
//

import Foundation
import Combine

protocol PaperServicerProtocol {
        
    var url: String {get}
    
    func querySearch(query: String) async throws -> [RAISummary]
    
    var name: String { get }
    
}


protocol RAISummaryEntryProtocol: Codable {
    
    var entries: [RAISummaryProtocol] {get}
}


protocol RAISummaryProtocol {
    var raiTitle: String { get }
    var raiAuthors: [String] { get }
    var raiPublished: String { get }
    var raiUpdated: String { get }
    var raiSummary: String { get }
    var raiLink: String { get }
    var raitags: [String] {get}
}

struct RAISummaryProtocolStub: RAISummaryProtocol {
    let raiTitle: String
    let raiAuthors: [String]
    let raiPublished: String
    let raiUpdated: String
    let raiSummary: String
    let raiLink: String
    var raitags: [String]
}
