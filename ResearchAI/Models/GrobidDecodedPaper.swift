//
//  Paper.swift
//  ResearchAI
//
//  Created by Sam Santos on 1/7/23.
//
//adding new
import Foundation

struct GrobidDecodedPaper: Decodable {
    
    let text: Text
    
    let teiHeader: TeiHeader

    struct TeiHeader: Decodable {
        let fileDesc: FileDesc


        struct FileDesc: Decodable {
            let titleStmt: TitleStmt


            struct TitleStmt: Decodable {
                let title: String
            }
        }
    }
    
    
    struct Text: Decodable {
        
        let body: Body
        
        struct Body: Decodable {
            
            let div : [Div]
            
            struct Div: Decodable {
            
                var head: String? = ""
                var paragraphs: [String]? = [""]

                   private enum CodingKeys: String, CodingKey {
                       case head
                       case paragraphs = "p"
                   }
                
                init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)

                    self.head = try container.decodeIfPresent(String.self, forKey: .head) ?? ""

                    do {
                        // Try to decode "p" as a single value
                        let singleValue = try container.decodeIfPresent(String.self, forKey: .paragraphs)
                        self.paragraphs = singleValue.map { [$0] } ?? [""]
                    } catch {
                        // If that fails, try to decode "p" as an array
                        self.paragraphs = try container.decodeIfPresent([String].self, forKey: .paragraphs) ?? [""]
                    }
                }
            
            }
            
        }
        
    }
    
    
}
