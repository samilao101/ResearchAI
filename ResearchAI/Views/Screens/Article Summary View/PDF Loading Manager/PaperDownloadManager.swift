//
//  PaperDownloadManager.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/3/23.
//

import Foundation
import Combine
import PDFKit

@MainActor
class PaperDownloadManager: NSObject, ObservableObject {
    
    override init() {}
    
    var progressPublisher = PassthroughSubject<Double, Never>()

    func fetchPaper(url: String) async -> (PDFDocument?, Data?) {
        do {
            let url = URL(string: url)!
            
            let (asyncBytes, urlResponse) = try await URLSession.shared.bytes(from: url)
            let length = urlResponse.expectedContentLength
            var data = Data()
            data.reserveCapacity(Int(length))
            
            var lastProgress: Double = 0.0
            let updateInterval = Int(length) / 100

            
            var downloadedBytes = 0
            for try await byte in asyncBytes {
                data.append(byte)
                downloadedBytes += 1
                
                if downloadedBytes % updateInterval == 0 {
                    let progress = Double(downloadedBytes) / Double(length)
                    if progress - lastProgress >= 0.1 {
                        await MainActor.run {
                            progressPublisher.send(progress)
                        }
                        lastProgress = progress
                    }
                }
            }
            
            return (PDFDocument(data: data)!, data)
        } catch {
            print(error.localizedDescription)
        }
        return (nil, nil)
    }


}
