import SwiftUI
import Speech


struct SpeakerButton: View {
    @Binding var transcription : String
    @State private var isAuthorized = false
    @State private var isRecording = false
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    @State var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    
    var body: some View {
        VStack {
            Text("Transcription:")
            Text(transcription)
                .font(.title)
            
            Button {
                if self.isRecording {
                    self.audioEngine.stop()
                    self.recognitionRequest?.endAudio()
                    self.isRecording = false
                } else {
                    self.startRecording()
                }
            } label: {
                Text(isRecording ? "Stop Recording" : "Start Recording")
                    .padding()
                    .padding(.horizontal)
                    .background(isRecording ? Color.green : Color.red)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }


            .disabled(!isAuthorized)
        }
        .onAppear(perform: requestAuthorization)

    }
    
    private func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                self.isAuthorized = authStatus == .authorized
            }
        }
    }
    
    
    private func startRecording() {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        
        recognitionRequest.shouldReportPartialResults = false
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.transcription = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.isRecording = false
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
              
              do {
                  try audioEngine.start()
              } catch {
                  print("There was an error starting the audio engine: \(error.localizedDescription)")
                  return
              }
              
              self.isRecording = true
          }
      }
