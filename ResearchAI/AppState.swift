//
//  AppState.swift
//  ResearchAI
//
//  Created by Sam Santos on 2/1/23.
//

import Foundation


class AppState: ObservableObject {
    
    let arxivQueryServicer = ArxivQueryService()
    let openAIServicer = OpenAIServicer()
    let storageManager = StorageManager()
    
    
    
    
}
