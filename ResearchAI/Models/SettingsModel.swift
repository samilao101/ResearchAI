//
//  URLModel.swift
//  ResearchAI
//
//  Created by Sam Santos on 1/15/23.
//

import Foundation


class SettingsModel: ObservableObject {
    
    static let shared = SettingsModel()
    
    @Published var currentURL: URL
    
    func setupAudioDefaults() {
        if !UserDefaults.standard.bool(forKey: Constant.log.hasTheUserEverLoggedInBefore) {

            UserDefaults.standard.set(1.0, forKey: Constant.AudioSettings.rate.rawValue)
            UserDefaults.standard.set(1.0, forKey: Constant.AudioSettings.pitch.rawValue)
            UserDefaults.standard.set(1.0, forKey: Constant.AudioSettings.volume.rawValue)

            UserDefaults.standard.set(true, forKey: Constant.log.hasTheUserEverLoggedInBefore)
            print("Setting defaults audio settings...")
        }
    }
    
    func storeAudioSettings<T: FloatingPoint>(setting: Constant.AudioSettings, value:T ) {
        
        switch setting {
        case .rate:
            UserDefaults.standard.set(value, forKey: Constant.AudioSettings.rate.rawValue)
        case .pitch:
            UserDefaults.standard.set(value, forKey: Constant.AudioSettings.pitch.rawValue)
        case .volume:
            UserDefaults.standard.set(value, forKey: Constant.AudioSettings.volume.rawValue)
        }
        
    }
    
    func retrieveAudioSettings(setting: Constant.AudioSettings) -> any FloatingPoint {
        
        switch setting {
        case .rate:
            return UserDefaults.standard.double(forKey: Constant.AudioSettings.rate.rawValue)
        case .pitch:
            return UserDefaults.standard.float(forKey: Constant.AudioSettings.pitch.rawValue)
        case .volume:
            return UserDefaults.standard.float(forKey: Constant.AudioSettings.volume.rawValue)
        }
        
        
    }
    
    
    init() {
        
        online =  !UserDefaults.standard.bool(forKey: Constant.UserDefaultkey.isItOnline)
        
        if online {
            
            currentURL = URL(string: Constant.URLstring.online)!
            
        } else {
            
            currentURL = URL(string: Constant.URLstring.local)!
        }
        
    }
    
    var online: Bool {
        
        didSet {
            if online {
               
                UserDefaults.standard.set(online, forKey: Constant.UserDefaultkey.isItOnline)
                currentURL = URL(string: Constant.URLstring.online)!

                
            } else {
                
                UserDefaults.standard.set(online, forKey: Constant.URLstring.online)
                currentURL = URL(string: Constant.URLstring.local)!

            }
        }
        
    }
    

    
}
