//
//  SavedArticlePDFView.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/8/23.
//

import SwiftUI
import PDFKit

struct SavedArticlePDFView: UIViewControllerRepresentable {
    
    @Binding var pdfDocument: PDFDocument
    
    @Binding var textAnnotation: String
    @Binding var isHighlighting: Bool
    @Binding var pdfData: Data
    @Binding var annotationText : String
    @Binding var selection: PDFSelection?
    @Binding var simplicationAnnotation: String
    
    func makeUIViewController(context: Context) -> UIViewController {
        let pdfViewController = PDFViewController(pdfDocument: pdfDocument) {
            data in
            print("passing data")
            pdfData = data
        }
        return pdfViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if isHighlighting {
            DispatchQueue.main.async {
                guard let controller = uiViewController as? PDFViewController else {return}
                controller.highlight()
                isHighlighting.toggle()
            }
          
        }
        
        if !annotationText.isEmpty {
            DispatchQueue.main.async {
                guard let controller = uiViewController as? PDFViewController else {return}
                controller.highlightAndAnnotate(text: annotationText, selection: selection!)
                annotationText = ""
                selection = nil
            }
        }
        
        if !simplicationAnnotation.isEmpty {
            DispatchQueue.main.async {
                guard let controller = uiViewController as? PDFViewController else {return}
                controller.simplificationAnnotation(text: simplicationAnnotation, selection: selection!)
                simplicationAnnotation = ""
                selection = nil
            }
        }
    }
    
   
    
}
