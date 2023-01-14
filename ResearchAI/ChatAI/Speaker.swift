//
//  Speaker.swift
//  SpeakGPT
//
//  Created by Sam Santos on 12/27/22.
//

import Foundation
import AVFoundation

protocol didFinishSpeakingProtocol {
    
    func didFinishSpeaking()
}


class Speaker: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    
    let synthesizer = AVSpeechSynthesizer()
    var delegate: didFinishSpeakingProtocol?
    
    @Published var rate: Double = 0.5 {
        didSet{
            UserDefaults.standard.set(rate, forKey: "rate")
        }
    }
    @Published var pitch: Float = 1.0 {
        didSet{
            UserDefaults.standard.set(pitch, forKey: "pitch")
        }
    }
    @Published var volume: Float = 1.0 {
        didSet{
            UserDefaults.standard.set(volume, forKey: "volume")
        }
    }
    
    func speak(text: String) {
        
        synthesizer.delegate = self
        
        let utterance = AVSpeechUtterance(string: text)
//        utterance.rate = rate
        utterance.pitchMultiplier = pitch
        utterance.volume = volume

        // Set the audio session category to "playAndRecord" and allow output to be played through the speaker if needed
        try! AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetoothA2DP])
        try! AVAudioSession.sharedInstance().setActive(true)

        synthesizer.speak(utterance)
        
        
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    func continueSpeaking() {
        synthesizer.continueSpeaking()
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // The speech synthesizer has finished speaking
        print("Finished speaking..")
        delegate?.didFinishSpeaking()
    }
    
    
}
