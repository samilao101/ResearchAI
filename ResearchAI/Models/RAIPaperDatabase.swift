//
//  RAIPaperDatabase.swift
//  ResearchAI
//
//  Created by Sam Santos on 2/7/23.
//

import Foundation



struct RAIPaperDatabase: Identifiable {
    
    var id = UUID().uuidString
    var model: RAISummaryEntryProtocol.Type
    var urlString: String
    var name: String 
    
    init(model: RAISummaryEntryProtocol.Type, url: String, name: String) {
        self.model = model
        self.name = name
        self.urlString = url
    }
    
}
