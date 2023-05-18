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
    
    @Published var showButtons = false {
        didSet {
            print("changing")
        }
    }
    


    @Published var showAIChat = false
    @Published var showPaper = false
    @Published var showNoteViewer = false 
    
    var imageExtractor = ImageExtractor()
    var speaker = SpeechService()
    var settingsModel = SettingsModel()
    var openAI = OpenAIServicer()
    
    @Published var fullText = ""
    @Published var textArray = [TextTypeString]()
    
    @Published var currentText: TextTypeString
    
    var comprehension: Comprehension
    var paper: ParsedPaper
    @Published var location = 0 {
        didSet {
            UserDefaults.standard.set(location, forKey: paper.id.uuidString)
            currentText = textArray[location]
        }
    }
    var savedPaper: Bool
    let line = "\n" + "\n"

    @Published var stop = true
    @Published var showSettings = false
    var simpleText = false
    var paused = false
    var pdfDocument : PDFDocument
    
    init(comprehension: Comprehension, savedPaper: Bool) {
        self.paper = comprehension.decodedPaper!
        self.comprehension = comprehension
        self.savedPaper = savedPaper
        self.currentText = TextTypeString(string: comprehension.decodedPaper?.title ?? "", type: .title)
        self.pdfDocument = comprehension.pdfDocument!
        setup()

    }
    deinit {
        speaker.pause()
        stop = true
        paused = false 
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
                            images.append(imageExtractor.extractImageWithCoordinates(coordinates: ref.attributes["coords"]!, pdfDocument: pdfDocument)!)
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
        
        
        print("Speaking: \(speakLocation)")
        speaker.speak(location: speakLocation, text: text, voiceType: .wavenetEnglishFemale) {
             print("Spoke: \(speakLocation)")
        }
        
        let next = speakLocation + 1
        
        if next < textArray.count {
            print("Checking while thinking")
            if !speaker.audioHotloader.checkIfItHasNext(location: next) {
                speaker.storeNext(text: textArray[next].string, location: next)
            }
        }

    }
    
    func goBackWard() {
        if location > 1 {
            location -= 1
        }
        speaker.pause()
        
        if !stop {
            speak(text: textArray[location].string, speakLocation: location)
        } else {
            paused = false
        }
    }
    
    
    func showSettingsView() {
        showSettings.toggle()
    }
    
    func goForward() {
        if location != textArray.count - 1 {
            location += 1
        }
        speaker.pause()
        
        if !stop {
            speak(text: textArray[location].string, speakLocation: location)
        } else {
            paused = false
        }
        
    }
    
    func repeatLastParagraph() {
        if location != 0 {
            location -= 1
        }
        speaker.pause()
    }
    
    func playAudio() {
        
        if stop {
            if !paused {
                startAudio()
            } else {
                stop = false
                speaker.play()
            }
        } else {
            paused = true
            stop = true
            speaker.pause()
        }
    }
    
    func startAudio() {
        stop = false
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
    
    
    

   
}
