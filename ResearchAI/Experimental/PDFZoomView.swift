//
//  PDFKitView.swift
//  PDFZoomExp
//
//  Created by Sam Santos on 6/2/23.
//

import SwiftUI
import PDFKit


struct PDFKitView: UIViewRepresentable {
    var url: URL
    @Binding var rect: CGRect  // specify the coordinates of the image you want to zoom into

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: self.url)
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        let page = pdfView.document!.page(at: 3)!
        
        // Zoom to rect
        let scale = pdfView.bounds.width / rect.width
        pdfView.scaleFactor = scale

        let pageBounds = page.bounds(for: pdfView.displayBox)

        // Convert rect origin from PDF space to view space.
        let viewSpacePoint = CGPoint(x: (rect.origin.x / pageBounds.width) * pdfView.bounds.width,
                                     y: ((pageBounds.height - rect.origin.y) / pageBounds.height) * pdfView.bounds.height)
        
        // Go to destination
        pdfView.go(to: PDFDestination(page: page, at: viewSpacePoint))
    }
}
