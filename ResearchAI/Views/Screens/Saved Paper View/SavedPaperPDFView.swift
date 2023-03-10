//
//  DocumentPDFViewer.swift
//  ResearchAI
//
//  Created by Sam Santos on 1/15/23.
//

import Foundation
import PDFKit
import SwiftUI

struct SavedPaperPDFView: View {
    
    let comprehensionLocalFileManager = LocalFileManager<Comprehension>(folder: .comprehensions , model: Comprehension.self )
    @State var pdfDocument: PDFDocument

    var showButton: Bool { !selectedText.isEmpty }
    @State var showSimplified = false
    @StateObject var viewModel = OpenAIServicer()
    @State var showReader = false
    @State var isHighlighting = false {
        didSet {
            if isHighlighting == false {
                selectedText = ""
            }
        }
    }
    let comprehension: Comprehension?
    
    @State private var selectedText = ""
    
    var body: some View{
        
            ZStack{
                SavedArticlePDFView(pdfDocument: $pdfDocument, textAnnotation: $selectedText, isHighlighting: $isHighlighting)
                    .onReceive(NotificationCenter.default.publisher(for: .PDFViewSelectionChanged)) { item in
                        guard let pdfView = item.object as? PDFView else { return }
                        self.selectedText = (pdfView.currentSelection?.string) ?? ""
                    }
                    .navigationTitle(comprehension?.summary?.raiTitle ?? "")
                VStack{
                    HStack{
                        if showButton {
                            Button {
                                showSimplified.toggle()
                                selectedText = ""
                                
                            } label: {
                                Text("Simplify")
                            }
                            .buttonModifier(color: .green)
                            Button {
                                isHighlighting.toggle()
                                selectedText = ""
                                print("save button pressed")
                                saveDocument()
                                
                            } label: {
                                Text("Highlight")
                            }
                            .buttonModifier(color: .green)
                        }
                        Spacer()
                        Button {
                            showReader.toggle()
                        } label: {
                            Text("Show Reader")
                        }
                        .buttonModifier(color: .orange)
                        
                    }
                    Spacer()
                    
                }
            
            
            
            
        }
        .onAppear {
            viewModel.setup()
        }
        .fullScreenCover(isPresented: $showReader) {
            ReaderView(openAI: viewModel, savedPaper: true, paper: (comprehension?.decodedPaper)!, showReader: $showReader )
        }
        .sheet(isPresented: $showSimplified) {
            SimplificationView(originalText: selectedText, viewModel: viewModel)
        }
    }
    
    private func saveDocument() {
        
        print("function fired")
        
        let compToSave = Comprehension(id: comprehension!.id, summary: comprehension!.summary, pdfData: pdfDocument.dataRepresentation(), decodedPaper: comprehension!.decodedPaper)
        comprehensionLocalFileManager.saveModel(object: compToSave, id: comprehension!.id.uuidString)
        
    }
}

