//
//  RAIPaperDatabase.swift
//  ResearchAI
//
//  Created by Sam Santos on 2/7/23.
//

import Foundation



struct Database: Identifiable {
    
    let id = UUID()
    let name : String
    let database: PaperServicerProtocol
    
}
