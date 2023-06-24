//
//  PDFToSummaryDecoder.swift
//  ResearchAI
//
//  Created by Sam Santos on 5/19/23.
//

import Foundation
import Alamofire
import XMLParsing


class PDFToSummaryDecoder  {
    
    func convertDataToSummary(data: Data) -> RAISummary? {
        
        let string = String(data: data, encoding: .utf8)
        
        let decoder = XMLDecoder()
        do {
            let tei = try decoder.decode(TEI.self, from: data)
            let summary = RAISummary(source: tei)
            return summary
            
        } catch(let error) {
            print("Unable to decode:")
            print("\(error)")
            return nil
        }
        
    }
    
}



