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
    init() {
        
    }
    
    private var client: OpenAISwift?
    
    func setup() {
        client = OpenAISwift(authToken: Constant.keys.OpenAI)
    }
    
    func send(text: String, completion: @escaping (String) -> Void) {
        print("starting...")
        client?.sendCompletion(with: text, maxTokens: 500, completionHandler: { result in
            switch result {
            case .success(let model):
                print("positive")
                let output = model.choices.first?.text ?? ""
                completion(output)
            case .failure(let error):
                print("Error from OpenAI:")
                print(error)
                
            }
        })
        
    }
    
}

final class OpenAISimplifyingServicer: ObservableObject {
    init() {
        
    }
    
    private var client: OpenAISwift?
    
    func setup() {
        client = OpenAISwift(authToken: Constant.keys.OpenAI)
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
    
}
