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
    
    var pdfDocument: PDFDocument
    let documentName: String
    @State var showButton = false
    @State var showSimplified = false
    @StateObject var viewModel = OpenAIServicer()
    @State var showReader = false
    let paper: ParsedPaper
    
    @State private var selectedText = "" {
        didSet {
            if selectedText != "" {
                showButton = true
            }
        }
    }
    
    var body: some View{
        HStack{
            ZStack{
                DocumentPDFView(pdfDocument: pdfDocument)
                    .onReceive(NotificationCenter.default.publisher(for: .PDFViewSelectionChanged)) { item in
                        guard let pdfView = item.object as? PDFView else { return }
                        self.selectedText = (pdfView.currentSelection?.string) ?? ""
                    }
                    .navigationTitle(documentName)
                VStack{
                    HStack{
                        if showButton {
                            Button {
                                showSimplified.toggle()
                            } label: {
                                Text("Simplify")
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
            if showSimplified {
                SimplificationView(originalText: selectedText, viewModel: viewModel)
            }
            
        }
        .onAppear {
            viewModel.setup()
        }
        .sheet(isPresented: $showReader) {
            ReaderView(openAI: viewModel, savedPaper: true, paper: paper )
        }
    }
}

