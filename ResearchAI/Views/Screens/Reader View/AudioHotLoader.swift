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
            print("it has it: \(location)")
            return true
        } else {
            print("it does not have it: \(location)")
            return false
        }
    }
    
    func returnNext (location: Int) -> Element? {
        if let value = Storage[location] {
            print("returned stored: \(location)")
            return value
        } else {
            print("it does not have next.")
            return nil
        }
    }
    
    func put(store: Element, location: Int) {
        print("Stored Next: \(location)")
        Storage.updateValue(store, forKey: location)
    }
    
   
    
}
