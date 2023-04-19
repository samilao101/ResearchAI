//
//  ReaderViewModel.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/20/23.
//

import Foundation
import SwiftUI
import PDFKit

enum TextType {
    case title
    case section
    case paragraph
}

struct TextTypeString {
    let string: String
    let type: TextType
    var ref: [REF]?
    var images: [UIImage]?
}

class ReaderViewModel: ObservableObject, didFinishSpeakingProtocol  {
    
    func didFinishSpeaking() {
        if !stop {
            if textArray.count > location - 1 {
                location += 1
                let text = textArray[location]
                speak(text: text.string, speakLocation: location)
            }
        }
    }
    
    
    
    var speaker = SpeechService()
    var settingsModel = SettingsModel()
    var openAI = OpenAIServicer()
    
    @Published var fullText = ""
    @Published var textArray = [TextTypeString]()
    
    @Published var currentText: TextTypeString
    
    var paper: ParsedPaper
    var location = 0 {
        didSet {
            currentText = textArray[location]
        }
    }
    var savedPaper: Bool
    let line = "\n" + "\n"

    var stop = true
    var showSettings = false
    var simpleText = false
    var paused = false
    var pdfDocument : PDFDocument
    
    init(parsedPaper: ParsedPaper, savedPaper: Bool, pdfDoc: PDFDocument) {
        self.paper = parsedPaper
        self.savedPaper = savedPaper
        self.currentText = TextTypeString(string: parsedPaper.title, type: .title)
        self.pdfDocument = pdfDoc
        setup()

    }
    deinit {
        speaker.pause()
        stop = true
    }
    
    func setup() {
        speaker.delegate = self
        compileTextArray()
        setLocation()
        setAudioSettings()
        
        stop = true
    }
    
    
    func compileTextArray() {
        textArray.append(TextTypeString(string: paper.title, type: .title, ref: nil))
        paper.sections.forEach { section in
            textArray.append(TextTypeString(string: section.head, type: .section, ref: nil))
            if section.figAndParagraph != nil {
                section.figAndParagraph?.forEach({ p in
                    
                    var images: [UIImage] = []
                    
                    p.ref.forEach { ref in
                        if ref.attributes["type"] == "figure" {
                            images.append(extractImageWithCoordinates(coordinates: ref.attributes["coords"]!)!)
                        }
                    }
                    
                    if !images.isEmpty {
                        textArray.append(TextTypeString(string: p.value, type: .paragraph, ref: p.ref, images: images))
                        print("got images")
                    } else {
                        textArray.append(TextTypeString(string: p.value, type: .paragraph, ref: p.ref, images: nil))
                        print("sorry no images")
                    }
                    
                })
            } else {
                print("nope!")
                section.paragraph.forEach { paragraph in
                    textArray.append(TextTypeString(string: paragraph, type: .paragraph))
                }
            }
        }
        
        
    }
    
    func setLocation() {

      location = UserDefaults.standard.integer(forKey: paper.id.uuidString)
        if location < 0 {
            location = 0
        }
        currentText = textArray[location]
    }
    
    func setAudioSettings() {
        speaker.rate = settingsModel.retrieveAudioSettings(setting: .rate) as! Double
        speaker.pitch = settingsModel.retrieveAudioSettings(setting: .pitch) as! Float
        speaker.volume = settingsModel.retrieveAudioSettings(setting: .volume) as! Float
    }
    
    func speak(text: String, speakLocation: Int) {
        speaker.speak(location: speakLocation, text: text, voiceType: .wavenetEnglishFemale) {
        }
        
        let next = speakLocation + 1
        if next < textArray.count {
            speaker.storeNext(text: textArray[next].string, location: next)
        }

    }

    
    func goBackWard() {
        if location > 1 {
            location -= 1
        }
        speaker.pause()
        speak(text: textArray[location].string, speakLocation: location)
    }
    
    
    func showSettingsView() {
        showSettings.toggle()
    }
    
    func goForward() {
        if location != textArray.count - 1 {
            location += 1
        }
        speaker.pause()
        speak(text: textArray[location].string, speakLocation: location)
        
    }
    
    func repeatLastParagraph() {
        if location != 0 {
            location -= 1
        }
        speaker.pause()
    }
    
    func playAudio() {
        if stop {
            speaker.play()
            stop.toggle()
        } else {
            speaker.pause()
            stop.toggle()
        }
    }
    
    func startAudio() {
        stop = false
        simpleText = false
        speaker.pause()
        let text = textArray[location]
        speak(text: text.string, speakLocation: location)
    }
    
    func simplifyAudio() {
        stop = false
        simpleText = true
        fullText = ""
        speaker.pause()
        didFinishSpeaking()
    }
    
    func extractImageWithCoordinates(coordinates: String) -> UIImage? {
        
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
    
    func extractImages(from document: PDFDocument, page: Int, x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) -> UIImage? {
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
