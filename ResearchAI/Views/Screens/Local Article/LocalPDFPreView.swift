//
//  PDFPreView.swift
//  ResearchAI
//
//  Created by Sam Santos on 5/17/23.
//

import SwiftUI

import Foundation
import SwiftUI
import PDFKit


struct LocalPDFPreView: View {
    
    @ObservedObject var appState : AppState
    @StateObject var paperDecoder = PaperDecoder()
    @Binding var goBack: Bool
    var paper: ParsedPaper?
    let pdf: PDFDocument
    @State var showReader = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                ZStack{
                    PDFResearchPaperView(pdfDocument: pdf)
                    VStack{
                        HStack{
                            backButton
                            Spacer()
                        }
                        Spacer()
                        HStack{
                            if paperDecoder.gotPaper {
                                readerButton
                                    .onAppear {
                                        appState.comprehension.decodedPaper = paperDecoder.paper
                                        
                                        appState.comprehension.summary
                                        = paperDecoder.summary
                                    }
                            } else {
                                 loadingView
                            }
                            Spacer()
                        }
                    }
                    .padding()
                }
            }
        }
        .fullScreenCover(isPresented: $showReader, content: {

            AudioPlayerView(readerViewModel: ReaderViewModel(comprehension: appState.comprehension, savedPaper: false), goBack: $showReader)
            
        })
        .onAppear {
            paperDecoder.sendPDF(withData: pdf.dataRepresentation()!)
            appState.comprehension.pdfData = pdf.dataRepresentation()!
        }
        
       
    }
    
//    func saveDocument() {
//        let comprehension = appState.comprehension
//        comprehensionLocalFileManager.saveModel(object: comprehension, id: comprehension.id.uuidString)
//        appState.getSavedAllComprehensions()
//    }
    
    
}

extension LocalPDFPreView {
    private var readerButton: some View {
        
        Button {
            
            if paperDecoder.paper != nil {
                showReader.toggle()
            }
            
        } label: {
            HStack{
                Image(systemName: "book")
                Text("Reader")
            }
        }
        .padding()
        .background(Color.black)
        .cornerRadius(8)
        .foregroundColor(.white)
        .padding(.bottom, 34)
        
    }
    
    private var backButton: some View {
        
        Button {
            goBack.toggle()
        } label: {
            ZStack{
                
                Circle()
                    .stroke(style: .init(lineWidth: 2))
                    .frame(width: 40)
                Circle()
                    .frame(width: 30)
                    .foregroundColor(.black)
                Text("**<**")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .padding()
        
    }
    
    private var loadingView: some View {
        HStack{
            ProgressView()
            Text("Decoding")
        }
        .padding()
        .background(Color.gray)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}
//
//struct PDFPreView_Previews: PreviewProvider {
//    static var previews: some View {
//        PDFPreView()
//    }
//}
