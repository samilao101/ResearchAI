//
//  PDFView.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/29/22.
//

import SwiftUI
import PDFKit
import Combine
import Alamofire



extension String {
    func toHttps() -> String {
        if self.starts(with: "http://") {
            return self.replacingOccurrences(of: "http://", with: "https://")
        } else {
            return self
        }
    }
}


//func sendPDF(pdfFileURL: URL, url: URL) {
//    let session = URLSession.shared
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//
//    let formData = MultipartFormData()
//
//    session.downloadTask(with: pdfFileURL) { (tempLocalUrl, response, error) in
//        if let tempLocalUrl = tempLocalUrl, error == nil {
//            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                print("Successfully downloaded. Status code: \(statusCode)")
//            }
//
//            do {
//                formData.append(tempLocalUrl, withName: "input")
//
//                request.setValue(formData.contentType, forHTTPHeaderField: "Content-Type")
//                request.httpBody = try formData.encode()
//
//                let task = session.dataTask(with: request) { data, response, error in
//                    if let error = error {
//                        print("Error: \(error)")
//                        return
//                    }
//
//                    guard let httpResponse = response as? HTTPURLResponse,
//                          (200...299).contains(httpResponse.statusCode) else {
//                        print("Error: Invalid HTTP response code")
//                        return
//                    }
//
//                    if let data = data, let xmlString = String(data: data, encoding: .utf8) {
//                        print(xmlString)
//                    } else {
//                        print("Error: Could not parse data as XML")
//                    }
//                }
//
//                task.resume()
//            } catch {
//                print("Error encoding form data: \(error)")
//            }
//        } else {
//            print("Error downloading file: \(String(describing: error))")
//        }
//    }.resume()
//}


struct PDFResearchPaperView: UIViewRepresentable {
    

    var pdfDocument: PDFDocument
    
    init(pdfDocument: PDFDocument) {
        self.pdfDocument  = pdfDocument
    
    }
    
    func makeUIView(context: Context) -> some UIView {
        let pdfView : PDFView = PDFView()
        
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
        pdfView.minScaleFactor = 0.5
        pdfView.maxScaleFactor = 5.0
    
        
        return pdfView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}



struct DocumentPDFView: UIViewRepresentable {
    
  
    var pdfDocument: PDFDocument
    
    func makeUIView(context: Context) -> some UIView {
        let pdfView : PDFView = PDFView()
        
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
        pdfView.minScaleFactor = 0.5
        pdfView.maxScaleFactor = 5.0
    
        
        return pdfView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
