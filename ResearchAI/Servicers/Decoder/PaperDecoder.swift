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
    var object: Object = Object(div: [DIV(head: "", p: [P(value: "", ref: [REF(attributes: ["":""], content: "")])])], figures: [FIGURE(attributes: ["": ""], head: "", label: "", figDesc: "")])
    
    private func getDecodedPaper(data: Data)  {
        
        
        do {
            let decoded = try XMLDecoder().decode(GrobidDecodedPaper.self, from: data)
//
            let parser = XMLParser(data: data)
            let handler = XMLHandler()
            parser.delegate = handler
            parser.parse()
            
            self.object = handler.currentObject
            
            let paper = ParsedPaper(title: decoded.teiHeader.fileDesc.titleStmt.title, sections: decoded.text.body.div.map({ division in
                         ParsedPaper.Section(head: division.head ?? "" , paragraph: division.paragraphs ?? [""] )}))

         
            var customPaper = ParsedPaper(title: decoded.teiHeader.fileDesc.titleStmt.title, sections: object.div.map({ div in
                ParsedPaper.Section(head: div.head, paragraph: div.p.map({ p in
                    p.value
                }), figAndParagraph: div.p)
            }))
            
            customPaper.figures = object.figures
           
            DispatchQueue.main.async {
                self.gotPaper = true
                self.paper = customPaper
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
    
    func sendPDF(withData: Data) {
        
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "https://kermitt2-grobid.hf.space/api/processFulltextDocument")!)
        request.httpMethod = "POST"

        let formData = MultipartFormData()
        
        let teiCoordinates = ["persName", "figure", "ref", "biblStruct", "formula"]
        
        do {
            formData.append(withData, withName: "input")
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

    }

    
    
    
}
