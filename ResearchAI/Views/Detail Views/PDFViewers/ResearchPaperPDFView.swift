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
    
    @EnvironmentObject var storageManager: StorageManager
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
    @State var pdfDocument : PDFDocument?
    @State var showSimpleText = false
    var paper: DecodedPaper?
    
    let displayedPDFURL: URL
    @StateObject var paperViewModel = DecodedPaperStorageManager()
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                ZStack{
                    PDFResearchPaperView(documentURL: displayedPDFURL)
                        .onReceive(NotificationCenter.default.publisher(for: .PDFViewSelectionChanged)) { item in
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
                            }
                            Spacer()
                            if self.pdfDocument != nil && paperDecoder.gotPaper == true {
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
            
            //        .sheet(isPresented: $showSimplified) {
            //            SimplificationView(originalText: selectedText, viewModel: viewModel)
            //
            //        }
        }
        .sheet(isPresented: $showSimpleText, content: {
            SimpleTextView(openAI: viewModel, savedPaper: false, paper: paperDecoder.paper!)
        })
        .onAppear {
            viewModel.setup()
            self.pdfDocument = PDFDocument(url: displayedPDFURL)!
            //            let url = URL(string: "http://localhost:8070/api/processFulltextDocument")
            //            sendPDF(pdfFileURL: displayedPDFURL, url: url!)
            paperDecoder.sendPDF(pdfFileURL: displayedPDFURL)
            storageManager.savedDocument = false 
            
        }
    }
    
    
}

extension ResearchPaperPDFView {
    
    private var saveButton: some View {
        
        Button {
            
            if !storageManager.savedDocument {
                
                storageManager.save(name: paperName, dataURL: displayedPDFURL, decodedPaper: paperDecoder.paper!)
                
            }
            
        } label: {
            Text(storageManager.savedDocument ? "Saved": "Save to Device")
        }
        .padding()
        .background(storageManager.savedDocument ? Color.blue : Color.green)
        .cornerRadius(8)
        .foregroundColor(.white)
        .padding(.bottom, 34)
        
        
    }
    
    private var readerButton: some View {
        
        Button {
            
            if paperDecoder.paper != nil {
                showSimpleText.toggle()
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
