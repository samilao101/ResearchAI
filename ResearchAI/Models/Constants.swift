//
//  Constants.swift
//  ResearchAI
//
//  Created by Sam Santos on 1/15/23.
//

import Foundation

struct Constant {
    
    struct URLstring {
        
        static let local = "http://192.168.12.152:8070/api/processFulltextDocument"

        static let online = "https://cloud.science-miner.com/grobid/api/processFulltextDocument"
        
        static let ArxivSearch = "https://export.arxiv.org/api/query?search_query=all:"
    }
    
    struct UserDefaultkey {
        
        static let isItOnline = "isItOnline"
    
    }
    
    struct prompt {
        
        static let simplifyAndSummarize = "summarize and simplify the following text in a way that a high school student would understand:"
        
    }
    
    struct keys {
        
        static let OpenAI = "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"
        
        static let GoogleTTS = "AIzaSyA5HlIBfcb8qdbYqznaWTykuGicC8PRIIA"
        
    }
    
    
}
