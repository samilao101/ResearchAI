//
//  SimpleTextView.swift
//  ResearchAI
//
//  Created by Sam Santos on 1/8/23.
//

import SwiftUI

struct PaperSpeaker: View, didFinishSpeakingProtocol {
    
    func didFinishSpeaking() {
        if !stop {
            if textArray.count > location - 1 {
                
                let text = textArray[location]
                
                if simpleText {
                    
                    let prompt = "\(Constant.prompt.simplifyAndSummarize) \(text)"
                    
                    openAI.send(text: prompt) { response in
                        
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
    
    @ObservedObject var appState : AppState = AppState.shared
    @ObservedObject var speaker = SpeechService()
    @ObservedObject var openAI : OpenAIServicer
    var settingsModel = SettingsModel()
    @State var savedPaper: Bool
    @State var fullText = ""
    let line = "\n" + "\n"
    @State var textArray = [String]()
    let paper: ParsedPaper
    @State var location = 0 {
        didSet {
            if savedPaper{
                UserDefaults.standard.set(location-1, forKey: paper.id.uuidString)
            }
        }
    }
    @State var stop = true
    @State var showSettings = false
    
    @State var simpleText = false
    @State var paused = false

    
    var body: some View {
        
        ScrollViewReader{ value in
            
            ZStack{
                VStack {
                    
                    ScrollView {
                        Text(fullText)
                            .padding()
                            .padding(.top, 8)
                            .id("view")
                    }
                    .onAppear {
                        openAI.setup()
                    }
                }
                VStack{
                    Spacer()
                    if showSettings {
                        AudioControlView(rate: $speaker.rate, pitch: $speaker.pitch, volume: $speaker.volume)
                    }
                    HStack{
                        Button {
                            
                            if location > 1 {
                                location -= 2
                                fullText = ""
                                for i in 0..<location {
                                    fullText = fullText + textArray[i] + line
                                }
                            }
                            
                            speaker.pause()
                            
                        } label: {
                            Text(" << ")
                        }
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        Button {
                            withAnimation {
                                showSettings.toggle()
                            }
                        } label: {
                            HStack{
                                Image(systemName: "person.wave.2")
                                Text("Audio")
                            }
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                        }
                        
                        Button {
                            
                            if location != textArray.count - 1 {
                                location += 1
                            }
                            
                            speaker.pause()
                            
                            
                            
                        } label: {
                            Text(" >> ")
                        }
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                    }
                    HStack{
                        Button {
                            
                            if location != 0 {
                                location -= 1
                                fullText = ""
                                for i in 0..<location - 1 {
                                    fullText = fullText + textArray[i] + line
                                }
                            }
                            
                            speaker.pause()
                            
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                        }
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        
                        Button {
                            
                            if stop {
                                speaker.play()
                                stop.toggle()
                            } else {
                                speaker.pause()
                                stop.toggle()
                            }
                            
                        } label: {
                            Image(systemName: stop ? "play" : "pause")
                        }
                        
                        .padding(.horizontal, 80)
                        .padding(.vertical, 12)
                        .background(Color.yellow)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        
                        Text("\(location)")
                            .padding()
                            .background(Color.yellow)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .padding(.top, 2)
                        
                    }
                    HStack{
                        Button {
                            
                            stop = false
                            simpleText = false
                            fullText = ""
                            speaker.pause()
                            didFinishSpeaking()
                            
                        } label: {
                            Text("Start")
                        }
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        
                        
                        Button {
                            
                            stop = false
                            simpleText = true
                            fullText = ""
                            speaker.pause()
                            didFinishSpeaking()
                            
                        } label: {
                            Text("Simplified")
                        }
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        
                    }
                }
            }
            
            .onChange(of: location) { _ in
                withAnimation {
                    value.scrollTo("view", anchor: .bottom)
                }
            }
            
        }
        .onAppear {
            speaker.delegate = self
            compileAllText()
            compileText()
            stop = true
            
            speaker.rate = settingsModel.retrieveAudioSettings(setting: .rate) as! Double
            speaker.pitch = settingsModel.retrieveAudioSettings(setting: .pitch) as! Float
            speaker.volume = settingsModel.retrieveAudioSettings(setting: .volume) as! Float
            
            location = UserDefaults.standard.integer(forKey: paper.id.uuidString)
            if location < 0 {
                location = 0
            }
            
           
        }
        .onDisappear {
            speaker.pause()
            stop = true
        }
        
        
        
    }
    
    func compileText() {
        
        textArray.append(paper.title)
        paper.sections.forEach { section in
            textArray.append(section.head)
            section.paragraph.forEach { paragraph in
                textArray.append(paragraph)
            }
        }
        print("finished compiling")
    }
    
    //
    func compileAllText(){
        fullText = fullText  + paper.title +  line
        
        paper.sections.forEach { section in
            
            fullText = fullText + section.head + line
            
            section.paragraph.forEach { paragraph in
                
                fullText = fullText + paragraph + line
            }
        }
        
        print("Finished compiling all text")
        
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
    
    
    
}



//struct SectionView: View {
//    let section: Paper.Section
//
//    var body: some View {
//        List {
//
//            ForEach(section.paragraph, id:\.self) { paragraph in
//                Text(paragraph)
//                    .frame(width: 300)
//            }
//        }.onAppear {
//            print("Section")
//        }
//    }
//
//}


//struct TextView: View {
//
//    @ObservedObject var openAI : OpenAIServicer
//
//    @State var text : String
//
//    var body: some View {
//
//        Text(text)
//            .onAppear {
//                print("appearing")
//                openAI.setup()
//                simplify(text: text)
//            }
//
//    }
//
//    func simplify(text: String)  {
//        let prompt = "rewrite and provide only a simplified version of this research paper in a way that a high school student would understand. Do not summarize, keep it as long as the original text: \(text). "
//        print("working on it")
//        openAI.send(text: prompt) { response in
//            self.text = response
//        }
//
//    }
//}


//struct SimpleTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        SimpleTextView(paper: <#Paper#>)
//    }
//}


//
////  SimpleTextView.swift
////  ResearchAI
////
////  Created by Sam Santos on 1/8/23.
////
//
//import SwiftUI
//
//struct SimpleTextView: View {
//
//    @ObservedObject var openAI = OpenAIServicer()
//    @State var fullText = ""
//
//    let paper: Paper
//
//    var body: some View {
//        ScrollView{
//        VStack {
//           Text(fullText)
//            }
//        }.onAppear {
//            openAI.setup()
//            compile()
//        }
//    }
//
//    func compile() {
//        fullText.append(contentsOf: paper.title)
//        paper.sections.forEach { section in
//            fullText.append(contentsOf: section.head)
//            section.paragraph.forEach { paragraph in
//                fullText.append(contentsOf: paragraph)
//            }
//        }
//        simplify(text: fullText)
//    }
//
//    func simplify(text: String){
//        let prompt = "rewrite and provide only a simplified version of this research paper in a way that a high school student would understand. Do not summarize, keep it as long as the original text: \(text). "
//        openAI.send(text: prompt) { response in
//            fullText = response
//        }
//    }
//}
//
//struct SectionView: View {
//    let section: Paper.Section
//
//    var body: some View {
//        Group {
//            Text(section.head)
//                .font(.headline)
//                .bold()
//            ForEach(section.paragraph, id:\.self) { paragraph in
//                Text(paragraph)
//            }
//        }
//    }
//}
//
////struct SimpleTextView_Previews: PreviewProvider {
////    static var previews: some View {
////        SimpleTextView(paper: <#Paper#>)
////    }
////}
//
//

