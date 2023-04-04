//
//  OverlayView.swift
//  ResearchAI
//
//  Created by Sam Santos on 4/2/23.
//

import SwiftUI

import SwiftUI

struct OverlayView: View {
    
    @StateObject var readerViewModel: ReaderViewModel
    @Binding var goBack: Bool
    
    var body: some View {
        ZStack {
            
            VStack{
                HStack {
                    
                    Spacer()
                    Button {
                        goBack.toggle()
                        readerViewModel.speaker.pause()
                        readerViewModel.stop = true
                    }
                    label: {
                        
                        Text("Back")
            
                        
                    }
                            .padding()
                            .background(.gray.opacity(0.3))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                              .stroke(.white, lineWidth: 1.0)
                                              .padding(6)
                            )
                            .foregroundColor(.white)
                            .padding(.top, 40)
                            .padding(.trailing)
                    
                    
                            
                }
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
    }
}

extension OverlayView {
    private var backWards: some View {
    Button { readerViewModel.goBackWard()}
    label: { Text(" << ")}
            .padding()
            .background(.gray.opacity(0.3))
            .cornerRadius(8)
            .foregroundColor(.white)
           
            .overlay(
                RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                              .stroke(.white, lineWidth: 1.0)
                              .padding(6)
            )
           
    }
    
    private var audioButton: some View {
    Button {withAnimation { readerViewModel.showSettingsView()}}
    label: { HStack{ Image(systemName: "person.wave.2")
            Text("Audio") }}
            .padding()
            .background(.gray.opacity(0.3))
            .cornerRadius(8)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                              .stroke(.white, lineWidth: 1.0)
                              .padding(6)
            )
    }
    
    private var forward: some View {
    Button { readerViewModel.goForward()}
    label: { Text(" >> ") }
            .padding()
            .background(.gray.opacity(0.3))
            .cornerRadius(8)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                              .stroke(.white, lineWidth: 1.0)
                              .padding(6)
            )
    }
    
    
    private var repeatButton: some View {
        Button { readerViewModel.repeatLastParagraph() }
    label: { Image(systemName: "arrow.counterclockwise")}
            .padding()
            .background(.gray.opacity(0.3))
            .cornerRadius(8)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                              .stroke(.white, lineWidth: 1.0)
                              .padding(6)
            )
    }
    
    private var play: some View {
        Button { readerViewModel.playAudio() }
    label: { Image(systemName: readerViewModel.stop ? "play" : "pause") }
        
            .padding(.horizontal, 80)
            .padding(.vertical, 12)
            .padding()
            .background(.gray.opacity(0.3))
            .cornerRadius(8)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                              .stroke(.white, lineWidth: 1.0)
                              .padding(6)
            )
    }
    
    private var locationview: some View {
        Text("\(readerViewModel.location)")
            .padding()
            .background(.gray.opacity(0.3))
            .cornerRadius(8)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                              .stroke(.white, lineWidth: 1.0)
                              .padding(6)
            )
    }
    
    private var startButton: some View {
        Button { readerViewModel.startAudio()}
        label: { Text("Start")}
            .padding()
            .background(.gray.opacity(0.3))
            .cornerRadius(8)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                              .stroke(.white, lineWidth: 1.0)
                              .padding(6)
            )
    }
    
    private var simpliefiedButton: some View {
        Button { readerViewModel.simplifyAudio()}
        label: { Text("Simplified")}
            .padding()
            .background(.gray.opacity(0.3))
            .cornerRadius(8)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                              .stroke(.white, lineWidth: 1.0)
                              .padding(6)
            )
    }
}

struct OverlayView_Previews: PreviewProvider {
    
    static let parsedPaper = ParsedPaper(title: "Effects of Data Geometry in Early Deep Learning", sections: [ParsedPaper.Section(head: "1 Introduction", paragraph: ["The capacity of Deep Neural Networks (DNNs) to approximate arbitrary functions given sufficient training data in the supervised learning setting is well known [Cybenko, 1989, Hornik et al., 1989, Anthony and Bartlett, 1999]. Several different theoretical approaches have emerged that study the effectiveness and pitfalls of deep learning. These studies vary in their treatment of neural networks and the aspects they study range from convergence [Allen-Zhu et al., 2019, Goodfellow and Vinyals, 2015], generalization [Kawaguchi et al., 2017, Zhang et al., 2017, Jacot et al., 2018, Sagun et al., 2018], function complexity [Montu ́far et al., 2014, Mhaskar and Poggio, 2016], adversarial attacks [Szegedy et al., 2014, Goodfellow et al., 2015] to representation capacity [Arpit et al., 2017]. Some recent theories have also been shown to closely match empirical observations [Poole et al., 2016, Hanin and Rolnick, 2019b, Kunin et al., 2020].", "One approach to studying DNNs is to examine how the underlying structure, or geometry, of the data interacts with learning dynamics. The manifold hypothesis states that high-dimensional real world data typically lies on a low dimensional manifold [Tenenbaum, 1997, Carlsson et al., 2007, Fefferman et al., 2013]. Empirical studies have shown that DNNs are highly effective in deciphering this underlying structure by learning intermediate latent representations [Poole et al., 2016]. The ability of DNNs to “flatten” complex data manifolds, using composition of seemingly simple piece-wise linear functions, appears to be unique [Brahma et al., 2016, Hauser and Ray, 2017].", "et al., 2018, Raghu et al., 2017]. The work by Hanin and Rolnick [2019a] on this topic stands out because they derive bounds on the average number of linear regions and verify the tightness of these bounds empirically for deep ReLU networks, instead of larger bounds that rarely materialize. Hanin and Rolnick [2019a] conjecture that the number of linear regions correlates to the expressive power of randomly initialized DNNs with piece-wise linear activations. However, they assume that the data is uniformly sampled from the Euclidean space Rd, for some d. By combining the manifold hypothesis with insights from Hanin and Rolnick [2019a], we are able to go further in estimating the number of linear regions and the average distance from linear boundaries. We derive bounds on how the geometry of the data manifold affects the aforementioned quantities." ]), ParsedPaper.Section(head: "2 Preliminaries and Background", paragraph: ["Our goal is to understand how the underlying structure of real world data matters for deep learning. We first provide the mathematical background required to model this underlying structure as the geometry of data. We then provide a summary of previous work on understanding the approximation capacity of deep ReLU networks via the complexity of linear regions. For the details on how our work fits into one of the two main approaches within the theory of DNNs, from the expressive power perspective or from the learning dynamics perspective, we refer the reader to Appendix C. "]), ParsedPaper.Section(head: "2.1 Data Manifold and Definitions ", paragraph: ["Figure 1: A 2D surface, here represented by a 2-torus, is embedded in a larger input space, R3. Suppose each point corresponds to an image of a face on this 2-torus. We can chart two curves: one straight line cutting across the 3D space and another curve that stays on the torus. Images corresponding to the points on the torus will have a smoother variation in style and shape whereas there will be images corresponding to points on the straight line that are not faces.", "We use the example of the MetFaces dataset [Karras et al., 2020a] to illustrate how data lies on a low dimensional manifold. The images in the dataset are 1028 × 1028 × 3 dimensional. By contrast, the number of realistic dimensions along which they vary are limited, e.g. painting style, artist, size and shape of the nose, jaw and eyes, background, clothing style; in fact, very few 1028 × 1028 × 3"])])
    
    static var previews: some View {
        OverlayView(readerViewModel: ReaderViewModel(parsedPaper: parsedPaper, savedPaper: true, pdfDoc: pdf), goBack: .constant(false))
    }
}
