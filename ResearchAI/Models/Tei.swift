//
//  Tei.swift
//  ResearchAI
//
//  Created by Sam Santos on 5/19/23.
//

import Foundation

struct TEI: Decodable, RAISummaryProtocol {
    
    var raiTitle: String {
        teiHeader.fileDesc.titleStmt.title
    }
    
    var raiAuthors: [String] {
        
        teiHeader.fileDesc.sourceDesc.biblStruct.analytic.authors.map { author in
            if let firstNames = author.persName?.forename,
               let lastNames = author.persName?.surname {
                let fullName = firstNames + lastNames
                let joined = fullName.joined(separator: " ")
                return joined
            } else {
                return ""
            }
            
            
        } .filter { !$0.isEmpty }
    }
    
    var raiPublished: String {
        ""
    }
    
    var raiUpdated: String {
        ""
    }
    
    var raiSummary: String {
        "summary"
    }
    
    var raiLink: String {
        ""
    }
    
    
    
    let teiHeader: TeiHeader
    
    struct TeiHeader: Decodable {
        
        let fileDesc: FileDesc
        
        let profileDesc: ProfileDesc
        
        struct ProfileDesc: Decodable {
            let abstract: Abstract
            
            enum CodingKeys: String, CodingKey {
                case abstract = "abstract"
            }
            
            struct Abstract: Decodable {
                let div: [Div]

                enum CodingKeys: String, CodingKey {
                    case div = "div"
                }

                init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    if let divArray = try? container.decode([Div].self, forKey: .div) {
                        self.div = divArray
                    } else if let singleDiv = try? container.decode(Div.self, forKey: .div) {
                        self.div = [singleDiv]
                    } else {
                        throw DecodingError.dataCorruptedError(forKey: .div, in: container, debugDescription: "Expected to decode either a Div or [Div].")
                    }
                }
                
                struct Div: Decodable {
                    let p: [String]

                    enum CodingKeys: String, CodingKey {
                        case p = "p"
                    }

                    init(from decoder: Decoder) throws {
                        let container = try decoder.container(keyedBy: CodingKeys.self)
                        if let pArray = try? container.decode([String].self, forKey: .p) {
                            self.p = pArray
                        } else if let singleP = try? container.decode(String.self, forKey: .p) {
                            self.p = [singleP]
                        } else {
                            throw DecodingError.dataCorruptedError(forKey: .p, in: container, debugDescription: "Expected to decode either a String or [String].")
                        }
                    }
                }
            }

        }
        
        struct FileDesc: Decodable {
            
            let titleStmt: TitleStmt
            
            let sourceDesc: SourceDesc
            
           
            
            struct TitleStmt: Decodable {
                let title: String
            }
        
            struct SourceDesc: Decodable {
                
                let biblStruct: BiblStruct
                
                enum CodingKeys: String, CodingKey {
                    case biblStruct = "biblStruct"
                }
                
                struct BiblStruct: Decodable {
                    let analytic: Analytic
                    
                    enum CodingKeys: String, CodingKey {
                        case analytic = "analytic"
                    }
                    
                    struct Analytic: Decodable {
                        let authors: [Author]
                        let title: String
                        
                        enum CodingKeys: String, CodingKey {
                            case authors = "author"
                            case title = "title"
                        }
                        
                        struct Author: Decodable {
                            let persName: PersName?
                            
                            
                            enum CodingKeys: String, CodingKey {
                                case persName = "persName"
                            }
                            
                            struct PersName: Decodable {
                                let forename: [String]
                                let surname: [String]
                                
                                enum CodingKeys: String, CodingKey {
                                    case forename = "forename"
                                    case surname = "surname"
                                }
                                
                                init(from decoder: Decoder) throws {
                                    let container = try decoder.container(keyedBy: CodingKeys.self)
                                    
                                    if let array = try? container.decode([String].self, forKey: .forename) {
                                        forename = array
                                    } else if let single = try? container.decode(String.self, forKey: .forename) {
                                        forename = [single]
                                    } else {
                                        throw DecodingError.dataCorruptedError(forKey: .forename, in: container, debugDescription: "Forename could not be decoded")
                                    }
                                    
                                    
                                    if let array = try? container.decode([String].self, forKey: .surname) {
                                        surname = array
                                    } else if let single = try? container.decode(String.self, forKey: .surname) {
                                        surname = [single]
                                    } else {
                                        throw DecodingError.dataCorruptedError(forKey: .surname, in: container, debugDescription: "Surname could not be decoded")
                                    }
                                    
                                }
                            }
                        }
                        
                        
                        
                    }
                }
            }
            
            
           
            
        }
    }
    
    
}
