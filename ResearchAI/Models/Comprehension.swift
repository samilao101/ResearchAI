//
//  Comprehension.swift
//  ResearchAI
//
//  Created by Sam Santos on 2/16/23.
//

import Foundation
import PDFKit

struct Comprehension: Codable, Identifiable {
    
    var pdfDocument : PDFDocument? {
        if pdfData == nil {
            return nil
        } else {
            return PDFDocument(data: pdfData!)
        }
    }
    
    var id = UUID()
    
    var summary: RAISummary?
    var pdfData : Data?
    var decodedPaper: ParsedPaper?
    
}
