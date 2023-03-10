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
    
    func makeUIViewController(context: Context) -> UIViewController {
        let pdfViewController = PDFViewController(pdfDocument: pdfDocument)
        return pdfViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if isHighlighting{
            DispatchQueue.main.async {
                guard let controller = uiViewController as? PDFViewController else {return}
                controller.highlight()
                pdfDocument = controller.pdfDocument
                isHighlighting.toggle()
            }
          
        }
    }
    
   
    
}
