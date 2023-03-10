//
//  OpenAIServicer.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/28/22.
//

import Foundation
import OpenAISwift
import SwiftUI
import AVFoundation
import Combine


final class OpenAIServicer: ObservableObject {
   
    init() {}
    
    private var client: OpenAISwift?
    
    func setup() {
        client = OpenAISwift(authToken: Constant.keys.OpenAI)
    }
    
    var chatMessages = [ChatMessage(role: .system, content: "You are a helpful ressearch assistant")]
    
//    func send(text: String, completion: @escaping (String) -> Void) {
//        print("starting...")
//        client?.sendCompletion(with: text, maxTokens: 500, completionHandler: { result in
//            switch result {
//            case .success(let model):
//                print("positive")
//                let output = model.choices.first?.text ?? ""
//                completion(output)
//            case .failure(let error):
//                print("Error from OpenAI:")
//                print(error)
//
//            }
//        })
//
//    }
    
    func send(text: String, completion: @escaping (String) -> Void) {
        print("starting...")
        
        chatMessages.append(ChatMessage(role: .user, content: text))
        
        client?.sendChat(with: chatMessages, completionHandler: { result in
            switch result {
                
            case .success(let response):
                print(response)
                self.chatMessages.append(response.choices.last?.message ?? ChatMessage(role: .system, content: "No response"))
                completion(response.choices.last?.message.content ?? "No response")
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
       
  
        
    }
 
    
}

final class OpenAISimplifyingServicer: ObservableObject {
    init() {
        
    }
    
    private var client: OpenAISwift?
    
    var chatMessages = [ChatMessage(role: .system, content: "You are a helpful ressearch assistant")]
    
    func setup() {
        client = OpenAISwift(authToken: Constant.keys.OpenAI)
        print("Sending chat")
        chat(text: "hello") { response in
            print("response")
        }
    }
    
    func send(text: String, completion: @escaping (String) -> Void) {
        
        let prompt = "\(Constant.prompt.simplifyAndSummarize) \(text). "
    
        client?.sendCompletion(with: prompt, maxTokens: 500, completionHandler: { result in
            print(result)
            switch result {
            case .success(let model):
                print("returned")
                let output = model.choices.first?.text ?? ""
                completion(output)
            case .failure(let error):
                print(error)
                
            }
        })
        
    }
    
    func chat(text: String, completion: @escaping (String) -> Void) {
        print("starting...")
        
        chatMessages.append(ChatMessage(role: .user, content: text))
        
        client?.sendChat(with: chatMessages, completionHandler: { result in
            switch result {
                
            case .success(let response):
                self.chatMessages.append(response.choices.last?.message ?? ChatMessage(role: .system, content: "No response"))
                completion(response.choices.last?.message.content ?? "No response")
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
       
  
        
    }
    
}
