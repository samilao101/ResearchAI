//
//  ReaderViewModel.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/20/23.
//

import Foundation

class ReaderViewModel: ObservableObject, didFinishSpeakingProtocol  {
    
    func didFinishSpeaking() {
        if !stop {
            if textArray.count > location - 1 {
                let text = textArray[location]
                if simpleText {
                    let prompt = "\(Constant.prompt.simplifyAndSummarize) \(text)"
                    openAI.send(text: prompt) { [self] response in
                        fullText = fullText + response + line
                        speak(text: response)
                        location += 1
                    }
                } else {
                    fullText = fullText + textArray[location] + line
                    speak(text: text)
                    location += 1
                }
            }
        }
    }
    
    var speaker = SpeechService()
    var settingsModel = SettingsModel()
    var openAI = OpenAIServicer()
    
    @Published var fullText = ""
    @Published var textArray = [String]()
    var paper: ParsedPaper
    var location = 0 {
        didSet {
            if savedPaper{
                UserDefaults.standard.set(location-1, forKey: paper.id.uuidString)
            }
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
        setup()

    }
    deinit {
        speaker.pause()
        stop = true
    }
    
    func setup() {
        speaker.delegate = self
        compileTextArray()
        compileFullText()
        setLocation()
        setAudioSettings()
        
        stop = true
    }
    
    
    func compileTextArray() {
        textArray.append(paper.title)
        paper.sections.forEach { section in
            textArray.append(section.head)
            section.paragraph.forEach { paragraph in
                textArray.append(paragraph)
            }
        }
    }
    
    func compileFullText() {
        textArray.append(paper.title)
        paper.sections.forEach { section in
            textArray.append(section.head)
            section.paragraph.forEach { paragraph in
                textArray.append(paragraph)
            }
        }
    }
    
    func setLocation() {
 
      location = UserDefaults.standard.integer(forKey: paper.id.uuidString)
        if location < 0 {
            location = 0
        }
        
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
            speaker.speak(text: text, voiceType: .wavenetEnglishFemale) {
            }
        }
        
    }
    
    func goBackWard() {
        if location > 1 {
            location -= 2
            fullText = ""
            for i in 0..<location {
                fullText = fullText + textArray[i] + line
            }
        }
        
        speaker.pause()
    }
    
    
    func showSettingsView() {
            showSettings.toggle()
    
    }
    
    func goForward() {
        if location != textArray.count - 1 {
            location += 1
        }
        
        speaker.pause()
    }
    
    func repeatLastParagraph() {
        if location != 0 {
            location -= 1
            fullText = ""
            for i in 0..<location - 1 {
                fullText = fullText + textArray[i] + line
            }
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
        fullText = ""
        speaker.pause()
        didFinishSpeaking()
    }
    
    func simplifyAudio() {
        stop = false
        simpleText = true
        fullText = ""
        speaker.pause()
        didFinishSpeaking()
    }
   
}
