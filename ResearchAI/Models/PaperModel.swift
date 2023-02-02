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
    
    let paper: ParsedPaper
    
    let pdf: PDFDocument
    
    let reading: ReadingEntity
    
    
}
