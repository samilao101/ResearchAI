//
//  RAISummary.swift
//  ResearchAI
//
//  Created by Sam Santos on 2/6/23.
//

import Foundation

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
}

struct RAISummaryProtocolStub: RAISummaryProtocol {
    let raiTitle: String
    let raiAuthors: [String]
    let raiPublished: String
    let raiUpdated: String
    let raiSummary: String
    let raiLink: String
}






struct RAISummary: Codable, Identifiable {
    
    var id: String = UUID().uuidString
    
    var source: RAISummaryProtocol?
    
    var raiTitle: String {
        source?.raiTitle.filter { !"\n".contains($0) } ?? ""
    }
    
    var raiAuthors: [String] {
        source?.raiAuthors ?? [""]
    }
    
    var raiPublished: String {
        source?.raiPublished ?? ""
    }
    
    var raiUpdated: String {
        source?.raiUpdated ?? ""
    }
    
    var raiSummary: String {
        source?.raiSummary.filter { !"\n".contains($0) } ?? ""
    }
    
    var raiLink: String {
        source?.raiLink.toHttps() ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case raiTitle
        case raiAuthors
        case raiPublished
        case raiUpdated
        case raiSummary
        case raiLink
        case id // add id property to CodingKeys
    }
        
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(raiTitle, forKey: .raiTitle)
        try container.encode(raiAuthors, forKey: .raiAuthors)
        try container.encode(raiPublished, forKey: .raiPublished)
        try container.encode(raiUpdated, forKey: .raiUpdated)
        try container.encode(raiSummary, forKey: .raiSummary)
        try container.encode(raiLink, forKey: .raiLink)
        try container.encode(id, forKey: .id) // encode id property
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let raiTitle = try container.decode(String.self, forKey: .raiTitle)
        let raiAuthors = try container.decode([String].self, forKey: .raiAuthors)
        let raiPublished = try container.decode(String.self, forKey: .raiPublished)
        let raiUpdated = try container.decode(String.self, forKey: .raiUpdated)
        let raiSummary = try container.decode(String.self, forKey: .raiSummary)
        let raiLink = try container.decode(String.self, forKey: .raiLink)
        let id = try container.decode(String.self, forKey: .id) // decode id property
        self.init(source: nil) // initialize with empty source
        self.source = RAISummaryProtocolStub(
            raiTitle: raiTitle,
            raiAuthors: raiAuthors,
            raiPublished: raiPublished,
            raiUpdated: raiUpdated,
            raiSummary: raiSummary,
            raiLink: raiLink
        )
        self.id = id // set decoded id
    }
    
    init(source: RAISummaryProtocol?) {
        self.source = source
    }
    
}

