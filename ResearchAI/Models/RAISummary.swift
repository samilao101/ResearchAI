//
//  RAISummary.swift
//  ResearchAI
//
//  Created by Sam Santos on 2/6/23.
//

import Foundation

protocol RAISummaryEntryProtocol: Decodable {
    
    var entries: [RAISummaryProtocol] {get}
}


protocol RAISummaryProtocol: Decodable {
    
    var raiTitle: String { get }
    var raiAuthors: [String] { get }
    var raiPublished:  String { get }
    var raiUpdated:  String { get }
    var raiSummary: String {get }
    var raiLink:  String { get }
    
}


struct RAISummary: Identifiable {
    var id: String {
        UUID().uuidString
    }
    
    
    var source: RAISummaryProtocol
    
    var raiTitle: String {
        source.raiTitle
    }
    
    var raiAuthors: [String] {
        source.raiAuthors
    }
    
    var raiPublished: String {
        source.raiPublished
    }
    
    var raiUpdated: String {
        source.raiUpdated
    }
    
    var raiSummary: String {
        source.raiSummary
    }
    
    var raiLink: String {
        source.raiLink
    }
    
    
    
    
}
