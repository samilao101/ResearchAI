//
//  SoundManager.swift
//  ResearchAI
//
//  Created by Sam Santos on 4/3/23.
//

import Foundation
import SwiftUI
import AVKit

class SoundManager {
            
    static let instance = SoundManager() // Singleton
    
    var player: AVAudioPlayer?
    
    enum SoundOption: String {
        case ding
    }
    
    func playSound(sound: SoundOption) {
        
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
}
