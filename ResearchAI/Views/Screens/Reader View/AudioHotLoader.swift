//
//  AudioHotLoader.swift
//  ResearchAI
//
//  Created by Sam Santos on 4/4/23.
//

import Foundation

class HotLoader<Element> {
        
    private var Storage = [Int: Element]()
    
    
    func checkIfItHasNext(location: Int) -> Bool {
        if let _ = Storage[location] {
            print("it has it")
            return true
        } else {
            print("it does not have it")
            return false
        }
    }
    
    func returnNext (location: Int) -> Element? {
        if let value = Storage[location] {
            print("value")
            return value
        } else {
            print("nil")
            return nil
        }
    }
    
    func put(store: Element, location: Int) {
        Storage.updateValue(store, forKey: location)
    }
    
   
    
}
