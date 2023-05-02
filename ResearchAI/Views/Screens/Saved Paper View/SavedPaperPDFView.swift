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
    
    @State var simplificationAnnotation: String = "" {
        didSet {
            if simplificationAnnotation == "" {
                selectedText = ""
                showAnnotationView.toggle()
            } else {
                selection = tempSelection
            }
        }
    }
    
    @State var isHighlighting = false {
        didSet {
            if isHighlighting == false {
                selectedText = ""
            }
        }
    }
    
    @State var annotationText : String = "" {
        didSet {
            print("does it get here: \(annotationText)")
            if annotationText == "" {
                selectedText = ""
                showAnnotationView.toggle()
            }
        }
    }
    
    @State var pdfDataBeingSaved: Data = Data()
    @EnvironmentObject var appState : AppState
    
    @State var showAnnotationView: Bool = false
   
    
    let comprehension: Comprehension?
    
    @State private var selectedText = "" 
    @State var selection: PDFSelection? = nil
    @State var tempSelection: PDFSelection? = nil
    
    var body: some View{
        
            ZStack{
                SavedArticlePDFView(pdfDocument: $pdfDocument, textAnnotation: $selectedText, isHighlighting: $isHighlighting, pdfData: $pdfDataBeingSaved, annotationText: $annotationText, selection: $selection, simplicationAnnotation: $simplificationAnnotation)
                    .onReceive(NotificationCenter.default.publisher(for: .PDFViewSelectionChanged)) { item in
                        guard let pdfView = item.object as? PDFView else { return }
                        tempSelection = pdfView.currentSelection
                        self.selectedText = (pdfView.currentSelection?.string) ?? ""
                    }
                    .navigationTitle(comprehension?.summary?.raiTitle ?? "")
                    .sheet(isPresented: $showAnnotationView) {
                        AnnotationEditorView(annotation: $annotationText, show: $showAnnotationView)
                    }
                VStack{
                    HStack{
                        Spacer()
                        if (comprehension?.decodedPaper) != nil {
                            Button {
                                showReader.toggle()
                            } label: {
                                Text("Show Reader")
                            }
                            .buttonModifier(color: .orange)
                        }
                        
                    }
                    Spacer()
                    if showButton {
                        HStack{
                            Button {
                                selection = tempSelection
                                showSimplified.toggle()
                                
                            } label: {
                                
                                HStack{
                                    Image(systemName: "brain")
                                    Text("Simplify")
                                }
                            }
                            .buttonModifier(color: .yellow)
                            .font(.subheadline)
                            Button {
                                isHighlighting.toggle()
                                selectedText = ""
                                print(" highlight pressed")
                                
                            } label: {
                                HStack{
                                    Image(systemName: "highlighter")
                                    Text("Highlight")
                                }
                            }
                            .buttonModifier(color: .green)
                            .font(.subheadline)
                            Button {
                                selection = tempSelection
                                showAnnotationView.toggle()
                                selectedText = ""
                                print("annotate pressed")
                                
                            } label: {
                                HStack{
                                    Image(systemName: "character.book.closed.fill")
                                    Text("Annotate")
                                }
                            }
                            .buttonModifier(color: .orange)
                            .font(.subheadline)
                        }
                    }
                    
                }
            
            
        }
        .onAppear {
            viewModel.setup()
        }
        .fullScreenCover(isPresented: $showReader) {
            AudioPlayerView(readerViewModel: ReaderViewModel( comprehension: comprehension!, savedPaper: true , pdfDoc: self.pdfDocument), goBack: $showReader)
        }
        .sheet(isPresented: $showSimplified) {
            SimplificationViewWithAnnotation(annotationText: $simplificationAnnotation, originalText: selectedText, viewModel: viewModel, show: $showSimplified)
        }
        .onChange(of: pdfDataBeingSaved) { newData in
            saveDocument(newData: newData)
        }
        .onDisappear {
            appState.getSavedAllComprehensions()

        }
    }
    
    private func saveDocument(newData: Data) {
        
        print("function fired")
        
        let compToSave = Comprehension(id: comprehension!.id, summary: comprehension!.summary, pdfData: newData, decodedPaper: comprehension!.decodedPaper)
        comprehensionLocalFileManager.saveModel(object: compToSave, id: comprehension!.id.uuidString)
        
    }
}

