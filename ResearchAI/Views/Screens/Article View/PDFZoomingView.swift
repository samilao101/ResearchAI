//
//  PDFZoomingView.swift
//  ResearchAI
//
//  Created by Sam Santos on 6/8/23.
//

import SwiftUI

import SwiftUI
import PDFKit

struct PDFZoomingView: UIViewRepresentable {
    var pdf: PDFDocument
    @Binding var locURLString: String // specify the coordinates of the image you want to zoom into

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.document = pdf
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        
        
        let locationArray  = locURLString.components(separatedBy: ":").compactMap({Double($0)})
        guard let pageNumber = locationArray.first else {return}
        let pageNumberInt = Int(pageNumber)
        
        let page = pdfView.document!.page(at: pageNumberInt-1)!

        let cropBox = page.bounds(for: .cropBox)

        let locX = locationArray[1]
        let locY = locationArray[2]
        
        // Create the rectangle with correct coordinates
        let rect = CGRect(x: locX, y: cropBox.height - locY, width: 200, height: 200)

        // Zoom to rect
//        let scale = pdfView.bounds.width / rect.width
        pdfView.scaleFactor = 1.5

//        let pageBounds = page.bounds(for: pdfView.displayBox)

//        // Convert rect origin from PDF space to view space.
//        let viewSpacePoint = CGPoint(x: (rect.origin.x / pageBounds.width) * pdfView.bounds.width,
//                                     y: ((pageBounds.height - rect.origin.y) / pageBounds.height) * pdfView.bounds.height)

        // Go to destination
//        pdfView.go(to: PDFDestination(page: page, at: CGPoint(x: CGFloat(locX), y: CGFloat(842-locY))))
        pdfView.go(to: PDFDestination(page: page, at: CGPoint(x: CGFloat(locX), y: CGFloat((1000-locY) + 200))
                                     ))
    }
}

//struct PDFZoomingView_Previews: PreviewProvider {
//    static var previews: some View {
//        PDFZoomingView()
//    }
//}
