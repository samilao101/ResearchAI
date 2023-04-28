//
//  ContentView.swift
//  SpeakGPT
//
//  Created by Sam Santos on 12/24/22.
//

import OpenAISwift
import SwiftUI
import AVFoundation
import Combine


struct AnswersGPT: View, isDoneTranscribing, didFinishSpeakingProtocol {

    
    @ObservedObject var viewModel : OpenAIServicer
    @ObservedObject var transcriptionDataService = TranscriptionDataService()
    var speaker = Speaker()
    
    @State var originalText : String
    @State var text = ""
    @State var textWriten = ""
    @State var models = [MessageBubble]()
    @State var lastText = "empty text"
    @State var isWorking = false
  
    
    var body: some View {
        ScrollView {
            HStack {
                TextField("Questions...", text: $textWriten)
                    .padding(6.0)
                    .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                  .stroke(.gray, lineWidth: 1.0))
                    .padding()
                Button("Send"){
                    sendWriten()
                }.foregroundColor(.primary)
            }
//            HStack {
//                Button {
//                    transcriptionDataService.dataService.record()
//                } label: {
//                    HStack{
//                        if transcriptionDataService.isRecording {
//                            Image(systemName: "nosign")
//                        } else {
//                            Image(systemName: "mic")
//
//                        }
//                    Text(transcriptionDataService.isRecording ? "Stop" : "Press to Speak")
//
//                    }
//                    .padding()
//                    .padding(.horizontal)
//                    .background(transcriptionDataService.isRecording ? Color.red : Color.green)
//                    .cornerRadius(8)
//                    .foregroundColor(.white)
//                }.disabled(!transcriptionDataService.isAuthorized)
//
//
//
//            }
//            Text(transcriptionDataService.dataService.transcription)
//                .foregroundColor(.white)
//                .font(.body)
            ForEach(models, id:\.self) { message in
                
                MessageBubble(text: message.text, source: message.source)
                
            }.animation(.default, value: models)
            
            Spacer()
    
        }
        .onAppear{
            transcriptionDataService.dataService.delegate = self
            speaker.delegate = self
            settingUP()
            print("done.")
        }
        .padding()
        
    }
    func settingUP(){
        viewModel.send(text: "can I ask some questions regarding this text: \(originalText)") { response in
            print(response)
        }
    }
    
    func send(){
        
        guard !transcriptionDataService.dataService.transcription.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
  
        print("sending request")
        models.insert(MessageBubble(text: "Me: \(transcriptionDataService.dataService.transcription)", source: .human), at: 0)
        viewModel.send(text: transcriptionDataService.dataService.transcription) { response in
            DispatchQueue.main.async {
                self.models.insert(MessageBubble(text: "ChatGPT: "+response, source: .bot), at: 0)
                transcriptionDataService.dataService.record()
                speaker.speak(text: response)
            }
        }
        
    }
    
    func itisdone() {
        send()
    }
    
    func didFinishSpeaking() {
        transcriptionDataService.dataService.record()
    }
    
    func sendWriten() {
        print(1)
        guard !textWriten.trimmingCharacters(in: .whitespaces).isEmpty else {
            print(2)
            return
        }

        if lastText != textWriten {
            print(3)
        models.insert(MessageBubble(text: "Me: \(textWriten)", source: .human), at: 0)
            print(4)
        viewModel.send(text: textWriten) { response in
            DispatchQueue.main.async {
                print(9)
                self.models.insert(MessageBubble(text: "ChatGPT: "+response, source: .bot), at: 0)
                self.textWriten = ""
            }
        }
            print(10)
        lastText = textWriten
        }
        
    }

}

