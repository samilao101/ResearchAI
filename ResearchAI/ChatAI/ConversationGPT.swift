//
//  ConversationGPT.swift
//  ResearchAI
//
//  Created by Sam Santos on 5/12/23.
//

import Foundation

import OpenAISwift
import SwiftUI
import AVFoundation
import Combine
import CoreData


struct ConversationGPT: View, isDoneTranscribing, didFinishSpeakingProtocol {
    @ObservedObject var viewModel : OpenAIServicer
    @ObservedObject var transcriptionDataService = TranscriptionDataService()
    var speaker = Speaker()
    
    let paperID: String
    let paragraph: Int
    let storage = ConversationStorage.instance
    
    @State var originalText : String
    @State var text = ""
    @State var textWriten = ""
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Conversation.timestamp, ascending: true)]) var chats: FetchedResults<Conversation> {
        didSet {
            let savedChats = chats.filter({$0.paperID == paperID && $0.paragraph == paragraph})
            let sorted = savedChats.sorted { conv1, conv2 in
                conv1.timestamp! < conv2.timestamp!
            }
            print("sorting")
            print(sorted)
            models = sorted.map({MessageBubble(text: $0.message ?? "", source: $0.source! == "human" ? .human : .bot)})
            models.removeFirst()
        }
    }
    @State var models = [MessageBubble]()
    @State var messages = [Conversation]()
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
            ForEach(messages, id:\.self) { message in
                
                MessageBubble(text: message.message!, source: message.source == "human" ? .human : .bot)
                
            }.animation(.default, value: models)
            
            Spacer()
    
        }
        .onAppear{
            transcriptionDataService.dataService.delegate = self
            speaker.delegate = self
            updateMessages()
            settingUP()
            print("done.")
        }
        .padding()
        
    }
    func settingUP(){
        
        viewModel.send(text: "can I ask some questions regarding this text: \(originalText)") { response in
            print(response)
        }
        
//        if messages.isEmpty {
//            viewModel.send(text: "can I ask some questions regarding this text: \(originalText)") { response in
//                print(response)
//            }
//        } else {
//
//            let mes = storage.getMessagesWithFirst(id: paperID, par: paragraph)
//            var text  = """
//                            user: Please provide a simplication of the following text: \(originalText).
//                            system: \(mes.first?.message)
//                            """
//            for conversation in mes.dropFirst() {
//                text.append("\(conversation.message)")
//            }
//
//
//        }

    }
    
    func updateMessages() {
        messages = storage.getMessages(id: paperID, par: paragraph)
    }
    

    
    func send(){
        
        guard !transcriptionDataService.dataService.transcription.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
  
        print("sending request")
        models.insert(MessageBubble(text: "Me: \(transcriptionDataService.dataService.transcription)", source: .human), at: 0)
        storage.saveConversation(paperID: paperID, paragraph: paragraph, source: "human", message: transcriptionDataService.dataService.transcription)
        
        viewModel.send(text: transcriptionDataService.dataService.transcription) { response in
            DispatchQueue.main.async {
                self.models.insert(MessageBubble(text: "ChatGPT: "+response, source: .bot), at: 0)
                storage.saveConversation(paperID: paperID, paragraph: paragraph, source: "bot", message: response)
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
        
        guard !textWriten.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        if lastText != textWriten {
            
            storage.saveConversation(paperID: paperID, paragraph: paragraph, source: "human", message: textWriten)
            
            updateMessages()
            
            
            viewModel.send(text: textWriten) { response in
                DispatchQueue.main.async {
                   
                    
                    storage.saveConversation(paperID: paperID, paragraph: paragraph, source: "bot", message: response)
                    
                    updateMessages()
                    self.textWriten = ""
                }
            }
            lastText = textWriten
        }
        
    }

}
