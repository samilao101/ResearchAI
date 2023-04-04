//
//  XMLHandler.swift
//  ResearchAI
//
//  Created by Sam Santos on 4/3/23.
//

import Foundation


struct Object: Identifiable {
    var id = UUID()
    var div: [DIV]
    var figures: [FIGURE]
}

struct DIV: Identifiable {
    var id = UUID()
    var head: String
    var p: [P]
}

struct P: Identifiable, Codable{
    var id = UUID()
    var value: String
    var ref: [REF]
}

struct REF: Identifiable, Codable {
    var id = UUID()
    var attributes: [String: String]
    var content: String
    
    var formattedAttributes: String {
        attributes.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
    }
}

struct FIGURE: Identifiable, Codable {
    var id = UUID()
    var attributes: [String:String]
    var head: String
    var label: String
    var figDesc: String
}


class XMLHandler: NSObject, XMLParserDelegate {
    
    enum elements: String {
        case none = "none"
        case div = "div"
        case head = "head"
        case p  = "p"
        case ref = "ref"
        case figure = "figure"
        case label = "label"
        case figDesc = "figDesc"
        case abstract = "abstract"
        
        
    }
    
    var divIndex = 0
    var pIndex = 0
    var refIndex = 0
    var figureIndex = 0
    
    
    
    var previousElement = elements.none
    var currentElement = elements.none
    var currentObject: Object = Object(div: [DIV(head: "", p: [P(value: "", ref: [REF(attributes: ["":""], content: "")])])], figures: [FIGURE(attributes: ["":""], head: "", label: "", figDesc: "")])
    var isItNested: Bool = false
    var skip = false
    
    var currentP = 0
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        
        if !skip {
            if currentElement != .none {
                if elementName != currentElement.rawValue  {
                    isItNested = true
                    previousElement = currentElement
                    
                }
            }
            if elementName == "abstract" {
                currentElement = .abstract
                skip = true
            } else if elementName == "div" {
                
                currentElement = .div
                if currentObject.div.count != divIndex {
                    currentObject.div.append(DIV(head: "", p: [P(value: "", ref: [REF(attributes: ["":""], content: "")])]))
                }
                
            } else if elementName == "head" {
                currentElement = .head
            } else if elementName == "p" {
                currentElement = .p
                if currentObject.div[divIndex].p.count != pIndex + 1 {
                    currentObject.div[divIndex].p.append(P(value: "", ref: [REF(attributes: ["":""], content: "")]))
                }
            } else if elementName == "ref" {
                currentElement = .ref
                if attributeDict["type"] == "figure" {
                    currentObject.div[divIndex].p.append(P(value: "", ref: [REF(attributes: ["":""], content: "")]))
                    pIndex += 1
                    refIndex = 0
                }
                if currentObject.div[divIndex].p[pIndex].ref.count != refIndex + 1 {
                    currentObject.div[divIndex].p[pIndex].ref.append(REF(attributes: attributeDict, content: ""))
                }
                
                currentObject.div[divIndex].p[pIndex].ref[refIndex].attributes = attributeDict
                
            } else if elementName == "figure" {
                currentElement = .figure
                if currentObject.figures.count != figureIndex + 1 {
                    currentObject.figures.append(FIGURE(attributes: ["":""], head: "", label: "", figDesc: ""))
                }
                currentObject.figures[figureIndex].attributes = attributeDict
            } else if elementName == "label"{
                currentElement = .label
            } else if elementName == "figDesc" {
                currentElement = .figDesc
            }
        }
        
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        switch currentElement {
        case .none:
            break
        case .div:
            break
        case .head:
            currentObject.div[divIndex].head.append(string)
        case .p:
            currentObject.div[divIndex].p[pIndex].value.append(string)
        case .ref:
            currentObject.div[divIndex].p[pIndex].ref[refIndex].content.append(string)
        case .figure:
            break
        case .label:
            currentObject.figures[figureIndex].label.append(string)
        case .figDesc:
            currentObject.figures[figureIndex].figDesc.append(string)
        case .abstract:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        
        if currentElement.rawValue == elementName {
            if isItNested {
                currentElement = previousElement
                isItNested = false
            } else {
                if currentElement == .div {
                    divIndex += 1
                    pIndex = 0
                } else if currentElement == .p {
                    pIndex += 1
                    refIndex = 0
                } else if currentElement == .ref {
                    refIndex += 1
                } else if currentElement == .figure {
                    figureIndex += 1
                } else if currentElement == .abstract {
                    skip = false
                }
                currentElement = .none
            }
        }
        
        
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Error parsing XML: \(parseError)")
    }
    
    func decoded() -> Object? {
        currentObject
    }
}
