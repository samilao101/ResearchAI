//
//  ConversationAndSimplication.swift
//  ResearchAI
//
//  Created by Sam Santos on 5/12/23.
//

import Foundation
import SwiftUI
import OpenAISwift

struct ConversationAndSimplification: View {
    @State var simplified: String = ""
    @State var originalText: String
    @ObservedObject var viewModel : OpenAIServicer
    
    let paperID: String
    let paragraph: Int
    let storage = ConversationStorage.instance


    
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
                ConversationGPT(viewModel: viewModel, paperID: paperID , paragraph: paragraph, originalText: originalText)
                    .environment(\.managedObjectContext, storage.context)
            }
            
        }
    }
            .onAppear{
                viewModel.setup()
                if let simplifiedText = storage.getSimplification(paperID: paperID, par: paragraph) {
                    simplified = simplifiedText
                } else {
                    let prompt = "rewrite and provide only a simplified version of this research paper summary in a way that a high school student would understand: \(originalText). Then provide a list of all the technical terms used in the text. "
                    viewModel.send(text: prompt) { response in
                        DispatchQueue.main.async {
                            simplified = response
                            saveResult(text: response)
                        }
                    }
                }
            }
    }
    
    func saveResult(text: String) {
        storage.saveConversation(paperID: paperID, paragraph: paragraph, source: "human", message: text)
    }
}
