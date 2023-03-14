//
//  SimplicationWithAnnotation.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/14/23.
//

import SwiftUI

import SwiftUI
import OpenAISwift

struct SimplificationViewWithAnnotation: View {
    
    @Binding var annotationText: String
    @State var simplified: String = ""
    @State var originalText: String
    @ObservedObject var viewModel : OpenAIServicer
    @Binding var show: Bool
    
    var body: some View {
    ScrollView{
        VStack {
            VStack{
                Text("Simplification:")
                    .bold()
                if simplified.isEmpty {
                    ProgressView()
                } else {
                    Text(simplified)
                }
                Spacer()
                HStack {
                    Button("Annotate Simplification") {
                        annotationText = simplified
                        show.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(simplified.isEmpty)
                }
            }
            .padding(6.0)
            .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                          .stroke(.gray, lineWidth: 1.0))
            .background(Color.yellow)
            .padding()
            
            if simplified != "" {
                AnswersGPT(viewModel: viewModel, originalText: originalText)
            }
            
        }
    }
            .onAppear{
                let prompt = "rewrite and provide only a simplified version of this research paper summary in a way that a high school student would understand: \(originalText). Then provide a list of all the technical terms used in the text. "
                viewModel.send(text: prompt) { response in
                    DispatchQueue.main.async {
                      simplified = response
                    }
                }
            }
    }
}

