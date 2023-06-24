//
//  Interfaces.swift
//  ResearchAI
//
//  Created by Sam Santos on 5/18/23.
//

import Foundation
import Combine
import PDFKit

protocol PaperManagerProtocol {
    
    var appState: AppState { get set }
    var summary: RAISummary? { get set }
    var pdfData: Data? { get set }
    var progressPublisher: PassthroughSubject<Double, Never> { get }
    
    func getPDFData() async -> PDFDocument?
    func saveSummary()
    func savePDFData()
}


protocol PaperViewProtocol {
    
    var paperManager: PaperManagerProtocol {get set}
    var pdf: PDFDocument? {get set}
    func fetchPaper() async
    
}
