//
//  ReaderViewModel.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/20/23.
//

import Foundation

enum TextType {
    case title
    case section
    case paragraph
}

struct TextTypeString {
    let string: String
    let type: TextType
}

class ReaderViewModel: ObservableObject, didFinishSpeakingProtocol  {
    
    func didFinishSpeaking() {
        if !stop {
            if textArray.count > location - 1 {
                location += 1
                let text = textArray[location]
                speak(text: text.string)
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
    
    init(parsedPaper: ParsedPaper, savedPaper: Bool) {
        self.paper = parsedPaper
        self.savedPaper = savedPaper
        self.currentText = TextTypeString(string: parsedPaper.title, type: .title)
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
        textArray.append(TextTypeString(string: paper.title, type: .title))
        paper.sections.forEach { section in
            textArray.append(TextTypeString(string: section.head, type: .section))
            section.paragraph.forEach { paragraph in
                textArray.append(TextTypeString(string: paragraph, type: .paragraph))
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
    
    func speak(text: String) {
        speaker.speak(text: text, voiceType: .wavenetEnglishFemale) {
        }
        
    }
    
    func speakAll() {
        textArray.forEach { text in
            speaker.speak(text: text.string, voiceType: .wavenetEnglishFemale) {
            }
        }
        
    }
    
    func goBackWard() {
        if location > 1 {
            location -= 1
        }
        speaker.pause()
        speaker.speak(text: textArray[location].string) {
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
        speaker.speak(text: textArray[location].string) {
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
        speak(text: text.string)
    }
    
    func simplifyAudio() {
        stop = false
        simpleText = true
        fullText = ""
        speaker.pause()
        didFinishSpeaking()
    }
   
}
