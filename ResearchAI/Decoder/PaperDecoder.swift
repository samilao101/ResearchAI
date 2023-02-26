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
        print("here")
        
        do {
            print("or here")
            let decoded = try XMLDecoder().decode(GrobidDecodedPaper.self, from: data)
            print("or here 2")

            let paper = ParsedPaper(title: decoded.teiHeader.fileDesc.titleStmt.title, sections: decoded.text.body.div.map({ division in
                         ParsedPaper.Section(head: division.head ?? "" , paragraph: division.paragraphs ?? [""] )}))
            print("or here 3")

            DispatchQueue.main.async {
                print("or here 4")

                self.gotPaper = true
                self.paper = paper
            }

            
        } catch(let error) {
            
            print("error decoding")
            print(error)
            
        }
        
    }
    
    func sendPDF(pdfFileURL: URL) {
//
////        let url = URL(string: "http://192.168.12.152:8070/api/processFulltextDocument")
//        let url = URL(string: "https://cloud.science-miner.com/grobid/api/processFulltextDocument")
        
        let session = URLSession.shared
        var request = URLRequest(url: SettingsModel.shared.currentURL)
        request.httpMethod = "POST"

        let formData = MultipartFormData()

        session.downloadTask(with: pdfFileURL) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }

                do {
                    formData.append(tempLocalUrl, withName: "input")

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
