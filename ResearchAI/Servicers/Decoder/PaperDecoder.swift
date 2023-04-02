//
//  DecodedPaper.swift
//  ResearchAI
//
//  Created by Sam Santos on 1/7/23.
//

import Foundation
import Alamofire
import XMLParsing


class PaperDecoder : ObservableObject {
    
    @Published var paper: ParsedPaper?
    @Published var gotPaper = false
    
    private func getDecodedPaper(data: Data)  {
        
        do {
//            print(String(data: data, encoding: .utf8))
            let decoded = try XMLDecoder().decode(GrobidDecodedPaper.self, from: data)
            let paper = ParsedPaper(title: decoded.teiHeader.fileDesc.titleStmt.title, sections: decoded.text.body.div.map({ division in
                         ParsedPaper.Section(head: division.head ?? "" , paragraph: division.paragraphs ?? [""] )}))

            print("abc")
            print(decoded)
            
            DispatchQueue.main.async {
                self.gotPaper = true
                self.paper = paper
            }
            
        } catch(let error) {
            print("Error decoding paper: \(error)")
        }
        
    }
    
    func sendPDF(pdfFileURL: URL) {
        
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "https://kermitt2-grobid.hf.space/api/processFulltextDocument")!)
        request.httpMethod = "POST"

        let formData = MultipartFormData()
        
        let teiCoordinates = ["persName", "figure", "ref", "biblStruct", "formula"]

        session.downloadTask(with: pdfFileURL) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }

                do {
                    formData.append(tempLocalUrl, withName: "input")
                    for coordinate in teiCoordinates {
                    formData.append(coordinate.data(using: .utf8)!, withName: "teiCoordinates")}
                    
                    request.setValue(formData.contentType, forHTTPHeaderField: "Content-Type")
                    request.httpBody = try formData.encode()

                    let task = session.dataTask(with: request) { data, response, error in
                        if let error = error {
                            print("Error: \(error)")
                            return
                        }

                        guard let httpResponse = response as? HTTPURLResponse,
                              (200...299).contains(httpResponse.statusCode) else {
                            print("Error: Invalid HTTP response code")
                            return
                        }

                        if let data = data, let _ = String(data: data, encoding: .utf8) {
                           self.getDecodedPaper(data: data)
                        } else {
                            print("Error: Could not parse data as XML")
                        }
                    }

                    task.resume()
                } catch {
                    print("Error encoding form data: \(error)")
                }
            } else {
                print("Error downloading file: \(String(describing: error))")
            }
        }.resume()
    }

    
    
    
}
