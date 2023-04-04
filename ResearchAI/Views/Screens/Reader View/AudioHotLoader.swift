//
//  AudioHotLoader.swift
//  ResearchAI
//
//  Created by Sam Santos on 4/4/23.
//

import Foundation

class HotLoader<Element> {
        
    private var Storage = [Int: Element]()
    
    func checkIfItHasNext(location: Int) -> Element? {
        if let value = Storage[location] {
            return value
        } else {
            return nil
        }
    }
    
    func put(store: Element, location: Int) {
        Storage.updateValue(store, forKey: location)
    }
    
}
