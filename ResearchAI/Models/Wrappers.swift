//
//  Wrappers.swift
//  ResearchAI
//
//  Created by Sam Santos on 2/4/23.
//

import Foundation
import Combine

@propertyWrapper
class DeboucedObservedObject<wrapped: ObservableObject>:ObservableObject {
    var wrappedValue: wrapped
    var subscription: AnyCancellable?
    
    init(wrapped: wrapped, delay: Double = 0.5) {
        wrappedValue = wrapped
        subscription = wrappedValue.objectWillChange
            .debounce(for: .seconds(delay), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.objectWillChange.send()
            })
        
    }
    
     
}
