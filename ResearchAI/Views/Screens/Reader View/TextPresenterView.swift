//
//  TextPresenterView.swift
//  ResearchAI
//
//  Created by Sam Santos on 4/1/23.
//

import SwiftUI

extension String {
    
    func localized() -> LocalizedStringKey {
        let local:LocalizedStringKey = LocalizedStringKey(self)
        return local
    }
}

struct TextPresenterView: View {
    
    @State var locationURL = ""
    @EnvironmentObject var readerViewModel : ReaderViewModel
    @State var showPDFFigure = false

    
    let text: TextTypeString
    
    var body: some View {
        ScrollViewReader{ value in
            GeometryReader{ geo in
                ScrollView(.vertical) {
                        presenterView
                        .frame(minHeight: geo.size.height) // Set the content’s min height to the parent
                        .id("top")

                }.onAppear {
                    value.scrollTo("top", anchor: .top)
                }
            }
        }
    }
}

extension TextPresenterView {
        
    
    @ViewBuilder private var presenterView: some View {
        switch text.type {
        case .title:
            Text(text.string)
                .font(.largeTitle)
                .fontWeight(.medium)
        case .section:
            Text(text.string)
                .font(.title)
        case .paragraph:
            Text(text.string.localized())
                .font(.headline)
                .environment(\.openURL, OpenURLAction { url in

                    showPDFFigure.toggle()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

                        getFigureLocation(fig: url.absoluteString)
                    }
                  return .handled
                })
                .padding()
                .sheet(isPresented: $showPDFFigure) {
                    ZStack{
                        PDFZoomingView(pdf: readerViewModel.pdfDocument, locURLString: $locationURL)
                        VStack {
                            HStack {
                                Spacer()
                                Button {
                                    locationURL = ""
                                    showPDFFigure.toggle()
                                } label: {
                                    Text("Done")
                                }
                                .buttonStyle(.borderedProminent)

                            }
                            Spacer()
                        }
                    }
                       
                }
        }
    }
    
    func getFigureLocation(fig: String) {
        let newFig = fig.replacingOccurrences(of: "#", with: "")
        print("New Figure")
        print(newFig)
        print(readerViewModel.paper.figures)
        
        if let figure = readerViewModel.paper.figures?.first(where: {$0.attributes["xml:id"] == newFig}) {
            print("Om here")
            let attributeCoords = figure.attributes["coords"]?.components(separatedBy: ";").first
            
            let structuredCoords = attributeCoords?.replacingOccurrences(of: ",", with: ":")
            if let structuredCoords = structuredCoords {
                locationURL = structuredCoords
                print(locationURL)
            }
        }
    }
}

struct ParagraphWithImageViewer: View {
    
    let text: TextTypeString
    @State var showImages = false
    let soundManager = SoundManager.instance
    
    var body: some View {
        
        ZStack {
            if showImages && (text.images != nil) {
                ImagesViewer(images: text.images!, done: $showImages)
            } else {
                Text(text.string.localized())
                    .font(.headline)
                    .environment(\.openURL, OpenURLAction { url in
//
                        
                        
                        
                      return .handled
                    })
                    .padding()
                
                if let _ = text.images {
                    VStack {
                        HStack {
                            Button("See Images") {
                                showImages.toggle()
                            }
                            .buttonStyle(.bordered)
                            .background(.black)
                            .foregroundColor(.white)
                            .onAppear {
                                soundManager.playSound(sound: .ding)
                            }
                            Spacer()
                        }
                        .padding(.top, 100)
                        Spacer()
                    }
                }
            }
            
        }
        
    }
}

struct ImagesViewer: View {
    
    var images: [UIImage]
    @Binding var done: Bool
    
    var body: some View {
        ZStack{
            VStack{
                Text("Figures:")
                ScrollView {
        
                        ForEach(images, id:\.self) { image in
                            Image(uiImage: image)
                                .resizable(resizingMode: .stretch)
                                .scaledToFit()

                        }
                        .padding(.horizontal, 40)
                    
                }
            }  .padding(.top, 100)
            VStack {
                HStack {
                    Button("Done.") {
                        done.toggle()
                    }
                    Spacer()
                }
                Spacer()
            }  .padding(.top, 60)
        }
      

        
    }
}

struct TextPresenterView_Previews: PreviewProvider {
    static var previews: some View {
   
        TextPresenterView(text: TextTypeString(string: "Machine Learning with ChatGPT", type: .title))
                .previewLayout(.sizeThatFits)
        TextPresenterView(text: TextTypeString(string: "Experimental Evidence", type: .section))
                .previewLayout(.sizeThatFits)
        TextPresenterView(text: TextTypeString(string: "Deep neural networks can approximate functions on different types of data, from images to graphs, with varied underlying structure. This underlying structure can be viewed as the geometry of the data manifold. By extending recent advances in the theoretical understanding of neural networks, we study how a randomly initialized neural network with piece-wise linear activation splits the data manifold into regions where the neural network behaves as a linear function. We derive bounds on the density of boundary of linear regions and the distance to these boundaries on the data manifold. This leads to insights into the expressivity of randomly initialized deep neural networks on non-Euclidean data sets. We empirically corroborate our theoretical results using a toy supervised learning problem. Our experiments demonstrate that number of linear regions varies across manifolds and the results hold with changing neural network architectures. We further demonstrate how the complexity of linear regions is different on the low dimensional manifold of images as compared to the Euclidean space, using the MetFaces dataset.", type: .paragraph))
                .previewLayout(.sizeThatFits)
    }
}
