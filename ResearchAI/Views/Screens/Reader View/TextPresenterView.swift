//
//  TextPresenterView.swift
//  ResearchAI
//
//  Created by Sam Santos on 4/1/23.
//

import SwiftUI

struct TextPresenterView: View {
    
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
            Text(text.string)
                .font(.headline)
                .padding()
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
