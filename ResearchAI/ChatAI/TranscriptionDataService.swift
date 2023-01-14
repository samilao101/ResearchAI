//
//  TranscriptionDataService.swift
//  SpeakGPT
//
//  Created by Sam Santos on 12/28/22.
//

import Foundation
import SwiftUI
import Combine

class TranscriptionDataService: ObservableObject {
    
    @Published var data: String = ""
    @ObservedObject var dataService = Recognizer()
    var cancellables = Set<AnyCancellable>()
    
    @Published  var isAuthorized = false
    @Published var isRecording = false
    
    init() {
        dataService.requestAuthorization()
        addSubcribers()
    }
    
    private func addSubcribers() {
        dataService.$transcription
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            } receiveValue: { returnedValue in
                self.data = returnedValue
            }.store(in: &cancellables)
        
        dataService.$isRecording
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            } receiveValue: { returnedValue in
                self.isRecording = returnedValue
            }.store(in: &cancellables)
        
        dataService.$isAuthorized
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            } receiveValue: { returnedValue in
                self.isAuthorized = returnedValue
            }.store(in: &cancellables)

    }
    
}
