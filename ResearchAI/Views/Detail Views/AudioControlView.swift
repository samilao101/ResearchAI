//
//  AudioControlView.swift
//  ResearchAI
//
//  Created by Sam Santos on 1/9/23.
//

import SwiftUI

struct AudioControlView: View {
    @Binding var rate: Double
    @Binding var pitch: Float
    @Binding var volume: Float

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "waveform.path")
                Text("Rate: \(rate)")
                Slider(value: $rate, in: 0.25...4, step: 0.05)
            }
            .padding(.top)
            HStack {
                Image(systemName: "music.note")
                Text("Pitch")
                Slider(value: $pitch, in: -20...20, step: 1.0)
            }
            HStack {
                Image(systemName: "speaker.wave.3")
                Text("Volume")
                Slider(value: $volume, in: 0...1, step: 0.05)
            }
            .padding(.bottom)
        }.background(.black)
            .cornerRadius(8)
    }
}

