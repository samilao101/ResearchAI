//
//  CustomPDFView.swift
//  ResearchAI
//
//  Created by Sam Santos on 1/15/23.
//

import Foundation
import SwiftUI
import PDFKit


struct ResearchPaperPDFView: View {
    
    let paperName: String
    @StateObject var viewModel = OpenAIServicer()
    @ObservedObject var appState : AppState = AppState.shared
    let comprehensionLocalFileManager = LocalFileManager<Comprehension>(folder: .comprehensions , model: Comprehension.self )
    @StateObject var paperDecoder = PaperDecoder()
    
    @State private var selectedText = "" {
        didSet {
            if selectedText != "" {
                showButton = true
            }
        }
    }
    @Binding var goBack: Bool
    @State var showButton = false
    @State var showSimplified = false
    @State var showSimpleText = false
    var paper: ParsedPaper?
    let pdf: PDFDocument
    let displayedPDFURL: URL
    @State var showReader = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                ZStack{
                    PDFResearchPaperView(pdfDocument: pdf)
                        .onReceive(NotificationCenter.default.publisher(for: .PDFDocumentDidBeginFind)) { item in
                            guard let pdfView = item.object as? PDFView else { return }
                            self.selectedText = (pdfView.currentSelection?.string) ?? ""
                        }
            
                    VStack{
                        HStack{
                            backButton
                            Spacer()
                            if showButton {
                                simplifyButton
                            }
                        }
                        
                        Spacer()
                       
                        HStack{
                            if paperDecoder.gotPaper {
                                readerButton
                                    .onAppear {
                                        appState.comprehension.decodedPaper = paperDecoder.paper
                                    }
                            } else {
                                VStack{
                                    ProgressView()
                                    Text("Decoding")
                                }
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                            Spacer()
                            if paperDecoder.gotPaper == true {
                                saveButton
                            }
                        }
                        
                    }
                    .padding()
                }
                
                
                if showSimplified {
                    SimplificationView(originalText: selectedText, viewModel: viewModel)
                        .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                        .stroke(.gray, lineWidth: 1.0))
                        .onAppear {
                            viewModel.setup()
                        }
                }
            }
            
        }
        .fullScreenCover(isPresented: $showReader, content: {
            ReaderView( showReader: $showReader, readerViewModel: ReaderViewModel(parsedPaper: paperDecoder.paper!, savedPaper: false))
        })
        .onAppear {
            viewModel.setup()
            paperDecoder.sendPDF(pdfFileURL: displayedPDFURL)
            comprehensionLocalFileManager.savedDocument = false
            
        }
    }
    
    
}

extension ResearchPaperPDFView {
    
    private var saveButton: some View {
        
        Button {
            
            if !comprehensionLocalFileManager.savedDocument {
                
                let comprehension = appState.comprehension
                comprehensionLocalFileManager.saveModel(object: comprehension, id: comprehension.id.uuidString)
                appState.getSavedAllComprehensions()
                goBack.toggle()
                
            }
            
        } label: {
            Text(comprehensionLocalFileManager.savedDocument ? "Saved": "Save to Device")
        }
        .padding()
        .background(comprehensionLocalFileManager.savedDocument ? Color.blue : Color.green)
        .cornerRadius(8)
        .foregroundColor(.white)
        .padding(.bottom, 34)
        
        
    }
    
    private var readerButton: some View {
        
        Button {
            
            if paperDecoder.paper != nil {
                showReader.toggle()
            }
            
        } label: {
            Text("Reader")
        }
        .padding()
        .background(Color.orange)
        .cornerRadius(8)
        .foregroundColor(.white)
        .padding(.bottom, 34)
        
    }
    
    private var backButton: some View {
        
        Button {
            goBack.toggle()
        } label: {
            Text("Back")
        }
        .padding()
        .background(Color.red)
        .cornerRadius(8)
        .foregroundColor(.white)
        .padding(.top, 34)
        
    }
    
    
    private var simplifyButton: some View {
        
        Button {
            showSimplified.toggle()
        } label: {
            Text("Simplify")
        }
        .padding()
        .background(Color.green)
        .cornerRadius(8)
        .foregroundColor(.white)
        .padding(.top, 34)
        
    }
    
    
    
}
