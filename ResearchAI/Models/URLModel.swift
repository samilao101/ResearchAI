//
//  URLModel.swift
//  ResearchAI
//
//  Created by Sam Santos on 1/15/23.
//

import Foundation


class URLModel: ObservableObject {
    
    static let shared = URLModel()
    
    @Published var currentURL: URL
    
    init() {
        
        online =  UserDefaults.standard.bool(forKey: Constant.UserDefaultkey.isItOnline)
        
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
