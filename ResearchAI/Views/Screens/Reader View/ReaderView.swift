//
//  SimpleTextView.swift
//  ResearchAI
//
//  Created by Sam Santos on 1/8/23.
//

import SwiftUI

struct ReaderView: View {
    
    @Binding  var showReader : Bool
    @StateObject var readerViewModel: ReaderViewModel
    
    var body: some View {
        ScrollViewReader{ value in
            ZStack{
                VStack {
                    doneButton
                    readerView
                }
                VStack{
                    Spacer()
                    if readerViewModel.showSettings {
                        AudioControlView(rate: $readerViewModel.speaker.rate, pitch: $readerViewModel.speaker.pitch, volume: $readerViewModel.speaker.volume)
                    }
                    HStack{
                        backWards
                        audioButton
                        forward
                    }
                    HStack{
                        repeatButton
                        play
                        locationview
                    }
                    HStack{
                        startButton
                        simpliefiedButton
                    }
                }
            }
            .onChange(of: readerViewModel.location) { _ in
                withAnimation {
                    value.scrollTo("view", anchor: .bottom)
                }
            }
            
        }
        .onDisappear {
            readerViewModel.speaker.pause()
            readerViewModel.stop = true
        }
    }
}
extension ReaderView {
    
    private var doneButton: some View {
        HStack {
            Spacer()
            Button("Done.") {
                showReader.toggle()
            }
            .padding(.horizontal)
        }
    }
    
    private var readerView: some View {
        ScrollView {
            Text(readerViewModel.fullText)
                .padding()
                .padding(.top, 8)
                .id("view")
                .textSelection(.enabled)
        }
    }
    
    private var backWards: some View {
    Button { readerViewModel.goBackWard()}
    label: { Text(" << ")}
    .buttonModifier(color: .yellow)
    }
    
    private var audioButton: some View {
    Button {withAnimation { readerViewModel.showSettingsView()}}
    label: { HStack{ Image(systemName: "person.wave.2")
            Text("Audio") }}
    .buttonModifier(color: .blue)
    }
    
    private var forward: some View {
    Button { readerViewModel.goForward()}
    label: { Text(" >> ") }
    .buttonModifier(color: .green)
    }
    
    private var repeatButton: some View {
        Button { readerViewModel.repeatLastParagraph() }
    label: { Image(systemName: "arrow.counterclockwise")}
            .buttonModifier(color: .yellow)
    }
    
    private var play: some View {
        Button { readerViewModel.playAudio() }
    label: { Image(systemName: readerViewModel.stop ? "play" : "pause") }
        
            .padding(.horizontal, 80)
            .padding(.vertical, 12)
            .background(Color.yellow)
            .cornerRadius(8)
            .foregroundColor(.white)
    }
    
    private var locationview: some View {
        Text("\(readerViewModel.location)")
            .buttonModifier(color: .yellow)
            .padding(.top, 2)
    }
    
    private var startButton: some View {
        Button { readerViewModel.startAudio()}
        label: { Text("Start")}
        .buttonModifier(color: .green)
    }
    
    private var simpliefiedButton: some View {
        Button { readerViewModel.simplifyAudio()}
        label: { Text("Simplified")}
        .buttonModifier(color: .orange)
    }
    
}

