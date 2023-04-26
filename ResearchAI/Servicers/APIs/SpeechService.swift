

import UIKit
import AVFoundation

enum VoiceType: String {
    case undefined
    case basicEnglishFemale = "en-US-Standard-E"
    case basicEnglishMale = "en-US-Standard-D"
    case wavenetEnglishFemale = "en-US-Wavenet-C"
    case wavenetEnglishMale = "en-US-Wavenet-J"
    case wavenetGermanFemale = "de-DE-Wavenet-A"
    case wavenetGermanMale = "de-DE-Wavenet-B"
}

let ttsAPIUrl = "https://texttospeech.googleapis.com/v1beta1/text:synthesize"


class SpeechService: NSObject, AVAudioPlayerDelegate, ObservableObject {
    
    var settingsModel = SettingsModel.shared
    
    var audioHotloader = HotLoader<Data>()
    
    @Published var rate: Double = 1.0 {
        didSet{
            settingsModel.storeAudioSettings(setting: .rate, value: rate)
        }
    }
    @Published var pitch: Float = 1.0 {
        didSet{
            settingsModel.storeAudioSettings(setting: .pitch, value: pitch)
        }
    }
    @Published var volume: Float = 1.0 {
        didSet{
            settingsModel.storeAudioSettings(setting: .volume, value: volume)
        }
    }

    static let shared = SpeechService()
    private(set) var busy: Bool = false
//    {
//        didSet {
//            print("Done.")
//        }
//    }
    
    var delegate: didFinishSpeakingProtocol?

    
    private var player: AVAudioPlayer?
    private var completionHandler: (() -> Void)?
    
    // Mine. Tried pause first. Well it's more of a stop.
    func pause() {
        player?.pause()
        busy = false
    }
    
    
    func storeNext(text: String, voiceType: VoiceType = .wavenetEnglishFemale, location: Int) {
        
        print("Storing Next: \(location)")
        if !audioHotloader.checkIfItHasNext(location: location) {
            DispatchQueue.global().async {
                let postData = self.buildPostData(text: text, voiceType: voiceType)
                let headers = ["X-Goog-Api-Key": Constant.keys.GoogleTTS, "Content-Type": "application/json; charset=utf-8"]
                let response = self.makePOSTRequest(url: ttsAPIUrl, postData: postData, headers: headers)

                // Get the `audioContent` (as a base64 encoded string) from the response.
                guard let audioContent = response["audioContent"] as? String else {
                    print("Invalid response: \(response)")
                    self.busy = false
                    return
                }
                
                // Decode the base64 string into a Data object
                guard let audioData = Data(base64Encoded: audioContent) else {
                    self.busy = false
                    return
                }
                
                self.audioHotloader.put(store: audioData, location: location)
            }
        }
    }
    
    // Speak function.
    func speak(location: Int, text: String, voiceType: VoiceType = .wavenetEnglishFemale, completion: @escaping () -> Void) {
        
        print(1)
        guard !self.busy else {
            print("Speech Service busy!")
            return
        }
        
        self.busy = true
    
        var audioData : Data? = nil
        print(2)

        DispatchQueue.global(qos: .background).async {
            print(3)
            
            print("checking while playing")
            if !self.audioHotloader.checkIfItHasNext(location: location) {
                
                let postData = self.buildPostData(text: text, voiceType: voiceType)
                let headers = ["X-Goog-Api-Key": Constant.keys.GoogleTTS, "Content-Type": "application/json; charset=utf-8"]
                let response = self.makePOSTRequest(url: ttsAPIUrl, postData: postData, headers: headers)

                // Get the `audioContent` (as a base64 encoded string) from the response.
                
                guard let audioContent = response["audioContent"] as? String else {
                    print("Invalid response: \(response)")
                    self.busy = false
                    DispatchQueue.main.async {
                        completion()
                    }
                    return
                }
                print(4)

                
                if let audioD = Data(base64Encoded: audioContent) {
                    print(5)
                    audioData = audioD
                } else {
                    self.busy = false
                    return
                }
                
                
            } else {
                
                print("from storage 3,4,5")
                if let audioD = self.audioHotloader.returnNext(location: location) {
                    audioData = audioD
                } else {
                    self.busy = false
                    return
                    
                }
                
            }
                
            DispatchQueue.main.async {
                print(6)

                if let audioData = audioData {
                    print(7)

                    let session = AVAudioSession.sharedInstance()
                        try! session.setCategory(.playback, mode: .default, options: [])
                        try! session.setActive(true)
                        
                    
                    self.completionHandler = completion
                    self.player = try! AVAudioPlayer(data: audioData)
                    self.player!.prepareToPlay()
                    self.player?.delegate = self
                    self.player!.play() // plays the audioData
                } else {
                    self.busy = false
                }
            }
            
          
        }
    }
    
    private func buildPostData(text: String, voiceType: VoiceType) -> Data {
        
        var voiceParams: [String: Any] = [
            // All available voices here: https://cloud.google.com/text-to-speech/docs/voices
            "languageCode": "en-US"
        ]
        
        if voiceType != .undefined {
            voiceParams["name"] = voiceType.rawValue
        }
        
        let params: [String: Any] = [
            "input": [
                "text": text
            ],
            "voice": voiceParams,
            "audioConfig": [
                // All available formats here: https://cloud.google.com/text-to-speech/docs/reference/rest/v1beta1/text/synthesize#audioencoding
                "audioEncoding": "LINEAR16",
                "speakingRate" : rate,
            ]
        ]

        // Convert the Dictionary to Data
        let data = try! JSONSerialization.data(withJSONObject: params)
        return data
    }
    
    // Just a function that makes a POST request.
    private func makePOSTRequest(url: String, postData: Data, headers: [String: String] = [:]) -> [String: AnyObject] {
        var dict: [String: AnyObject] = [:]
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = postData

        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        // Using semaphore to make request synchronous
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                dict = json // Here was an !
            }
            
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return dict
    }
    
    // Implement AVAudioPlayerDelegate "did finish" callback to cleanup and notify listener of completion.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player?.delegate = nil
        self.player = nil
        self.busy = false
        
        self.completionHandler!()
        self.completionHandler = nil
        
        delegate?.didFinishSpeaking()
    }
    
    func play() {
     
        
        player?.play()
    }
}
