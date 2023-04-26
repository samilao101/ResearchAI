//
//  ImageExtractor.swift
//  ResearchAI
//
//  Created by Sam Santos on 4/24/23.
//

import Foundation
import SwiftUI
import PDFKit

struct ImageExtractor {
    
    func extractImageWithCoordinates(coordinates: String, pdfDocument: PDFDocument) -> UIImage? {
        
        let coordinateValues = coordinates.split(separator: ",").compactMap { Double($0) }

        if coordinateValues.count == 5 {
            let page = Int(coordinateValues[0]) - 1 // Convert to zero-based index
            let x1 = CGFloat(coordinateValues[1])
            let y1 = CGFloat(coordinateValues[2])
            let x2 = CGFloat(coordinateValues[3])
            let y2 = CGFloat(coordinateValues[4])

            if let image = extractImages(from: pdfDocument, page: page, x1: x1, y1: y1, x2: x2, y2: y2) {
               return image
            } else {
                return nil
            }
        } else {
            print("Error: Invalid coordinates format.")
            return nil
        }
        
    }
    
    private func extractImages(from document: PDFDocument, page: Int, x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) -> UIImage? {
        guard let pdfPage = document.page(at: page) else {
            print("Error: Unable to access the PDF page.")
            return nil
        }

        let cropBox = pdfPage.bounds(for: .cropBox)
        let rect = CGRect(x: min(x1, x2), y: cropBox.height - max(y1, y2), width: abs(x2 - x1), height: abs(y2 - y1))

        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }

        context.translateBy(x: -rect.origin.x, y: -rect.origin.y)
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -cropBox.height)
        pdfPage.draw(with: .cropBox, to: context)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
    
    
}
