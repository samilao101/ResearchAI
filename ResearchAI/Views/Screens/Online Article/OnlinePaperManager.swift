//
//  OnlinePaperManager.swift
//  ResearchAI
//
//  Created by Sam Santos on 5/18/23.
//

import Foundation
import PDFKit
import Combine
import SwiftUI

class OnlinePaperManager: PaperManagerProtocol {
    var appState: AppState
    
    var summary: RAISummary?
    var pdfData: Data?
    var pdfDecoded: ParsedPaper?
    
    @Published var gotPaper = false
    
    var progressPublisher = PassthroughSubject<Double, Never>()
    var paperDecoder = PaperDecoder()
    
    
    init(appState: AppState, summary: RAISummary? = nil) {
        self.appState = appState
     
    }
    
    func getPDFData() async -> PDFDocument? {
        
        return PDFDocument()
    }
    
    func saveSummary() {
        
    }

    
    @MainActor func savePDFData() {
        if let pdfData = pdfData {
            appState.comprehension.pdfData = pdfData
        }
    }
    
    
    @MainActor func saveDecodedPDF() {
        if let pdfDecoded = pdfDecoded {
            appState.comprehension.decodedPaper = pdfDecoded
        }
        
    }
    
    
    func downloadPaper(url: URL) {
        
    }
    
    
    
    
}
