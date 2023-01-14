import SwiftUI
import Speech

protocol isDoneTranscribing {
    func itisdone()
}

class Recognizer: NSObject, ObservableObject, SFSpeechRecognitionTaskDelegate {
    
  

    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishRecognition recognitionResult: SFSpeechRecognitionResult) {
        transcription = recognitionResult.bestTranscription.formattedString
        doneTranscribing = false
        print(doneTranscribing)

        let transcription = recognitionResult.bestTranscription
           for (index, segment) in transcription.segments.enumerated() {
               _ = segment.substringRange
               if index == transcription.segments.count - 1 {
                   // This is the last segment in the transcription, so the transcription of the sentence has finished
                   doneTranscribing = true
                   delegate?.itisdone()
               }
           }
        
    }
     
    @Published var doneTranscribing = false
    @Published var transcription : String = ""
    @Published  var isAuthorized = false
    @Published var isRecording = false
    var delegate: isDoneTranscribing?
    
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    private var recognitionTask: SFSpeechRecognitionTask?
   
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
             DispatchQueue.main.async {
                 // Print the authStatus value.
                 print(authStatus)

                 switch authStatus {
                 case .authorized:
                     // Start recording and transcribing speech.
                     self.transcription = "...Ready..."
                     self.isAuthorized = authStatus == .authorized
                     print("Is authorized.")
                 case .denied:
                     self.transcription = "User denied access to speech recognition."
                     print("Is denied.")

                 case .restricted:
                     self.transcription = "Speech recognition restricted on this device."
                     print("is restricted.")
                 case .notDetermined:
                     self.transcription = "Speech recognition not yet authorized."
                     print("Not determined.")
                 @unknown default:
                     self.transcription = "An unknown error occurred."
                     print("Unknown error.")
                 }
             }
    }
    }
    
    func record() {
        if self.isRecording {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.isRecording = false
        } else {
            do {
            try self.startRecording()
            } catch {
                print("error starting recording")
            }
        }
    }
    
    func send(string: String) -> String {
        return string
    }
    
    func startRecording() throws {
        
            self.isRecording = true


            recognitionTask?.cancel()

            self.recognitionTask = nil

            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            let inputNode = audioEngine.inputNode
            inputNode.removeTap(onBus: 0)
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
            recognitionRequest.shouldReportPartialResults = true

            if #available(iOS 13, *) {
                if speechRecognizer?.supportsOnDeviceRecognition ?? false {
                    recognitionRequest.requiresOnDeviceRecognition = true
                }
            }
        
        
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, delegate: self)
        
            
        }
      }

