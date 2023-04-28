//
//  SimplificationView.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/29/22.
//

import SwiftUI
import OpenAISwift

struct SimplificationView: View {
    @State var simplified: String = ""
    @State var originalText: String
    @ObservedObject var viewModel : OpenAIServicer

    
    var body: some View {
    ScrollView{
        VStack {
            VStack{
                Text("Paragraph Simplification:")
                    .bold()
                    .underline()
                if simplified.isEmpty {
                   ProgressView()
                        .foregroundColor(.black)
                    HStack {
                        Spacer()
                    }
                } else {
                    Text(simplified)
                }
            }
            .padding(6.0)
            .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                          .stroke(.gray, lineWidth: 1.0))
            .padding()
            
            if simplified != "" {
                AnswersGPT(viewModel: viewModel, originalText: originalText)
            }
            
        }
    }
            .onAppear{
                viewModel.setup()
                let prompt = "rewrite and provide only a simplified version of this research paper summary in a way that a high school student would understand: \(originalText). Then provide a list of all the technical terms used in the text. "
                viewModel.send(text: prompt) { response in
                    DispatchQueue.main.async {
                      simplified = response
                    }
                }
            }
    }
}




