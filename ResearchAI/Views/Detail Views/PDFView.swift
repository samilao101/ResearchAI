//
//  PDFView.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/29/22.
//

import SwiftUI
import PDFKit
import Combine
import Alamofire


struct ResizableSplitView<Content1: View, Content2: View>: View {
    let content1: Content1
    let content2: Content2
    @State private var dividerPosition: CGFloat = 0.5

    var body: some View {
        VStack {
            HStack {
                content1
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                content2
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            }
            .frame(height: 100)
            .overlay(
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.dividerPosition = value.location.x / UIScreen.main.bounds.width
                            }
                    )
            )
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}


extension String {
    func toHttps() -> String {
        if self.starts(with: "http://") {
            return self.replacingOccurrences(of: "http://", with: "https://")
        } else {
            return self
        }
    }
}




func sendPDF(pdfFileURL: URL, url: URL) {
    let session = URLSession.shared
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let formData = MultipartFormData()

    session.downloadTask(with: pdfFileURL) { (tempLocalUrl, response, error) in
        if let tempLocalUrl = tempLocalUrl, error == nil {
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                print("Successfully downloaded. Status code: \(statusCode)")
            }

            do {
                formData.append(tempLocalUrl, withName: "input")

                request.setValue(formData.contentType, forHTTPHeaderField: "Content-Type")
                request.httpBody = try formData.encode()

                let task = session.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error: \(error)")
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        print("Error: Invalid HTTP response code")
                        return
                    }

                    if let data = data, let xmlString = String(data: data, encoding: .utf8) {
                        print(xmlString)
                    } else {
                        print("Error: Could not parse data as XML")
                    }
                }

                task.resume()
            } catch {
                print("Error encoding form data: \(error)")
            }
        } else {
            print("Error downloading file: \(String(describing: error))")
        }
    }.resume()
}



struct CustomPDFView: View {
    
    let paperName: String
    @EnvironmentObject var pdfManager: PDFManager
    @StateObject var viewModel = OpenAIServicer()
    @StateObject var paperDecoder = DedodedPaper()
    
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
    var paper: Paper?

    let displayedPDFURL: URL
    @StateObject var paperViewModel = PaperViewModel()
    
    var body: some View {
        GeometryReader { geometry in
        HStack{
        ZStack{
        PDFKitRepresentedView(documentURL: displayedPDFURL)
                .onReceive(NotificationCenter.default.publisher(for: .PDFViewSelectionChanged)) { item in
                          guard let pdfView = item.object as? PDFView else { return }
                    self.selectedText = (pdfView.currentSelection?.string) ?? ""
                }
                           
            VStack{
                HStack{
                    if showButton {
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

                    Spacer()
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
                Spacer()
                if !pdfManager.savedDocument {
                    HStack{
                        if paperDecoder.gotPaper {
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
                        Spacer()
                        if self.pdfDocument != nil && paperDecoder.gotPaper == true {

                        Button {
                                pdfManager.save(pdf: pdfDocument!, withName: paperName, dataURL: displayedPDFURL)
                                paperViewModel.savePaper(paperToSave: paperDecoder.paper!, name: paperName)
                                print("saved paper")
                          
                            
                        } label: {
                            Text(pdfManager.savedDocument ? "Saved": "Save to Device")
                        }
                        .padding()
                        .background(pdfManager.savedDocument ? Color.blue : Color.green)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .padding(.bottom, 34)
                        }
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
            
        }
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    
    let documentURL: URL
    var pdfDocument: PDFDocument = PDFDocument()
    
    init(documentURL: URL) {
        self.documentURL = documentURL
        self.pdfDocument = PDFDocument(url: self.documentURL)!
    }
    
    func makeUIView(context: Context) -> some UIView {
        let pdfView : PDFView = PDFView()
        
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
        pdfView.minScaleFactor = 0.5
        pdfView.maxScaleFactor = 5.0
    
        
        return pdfView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

struct DocumentPDFViewer: View {
    
    var pdfDocument: PDFDocument
    let documentName: String
    @State var showButton = false
    @State var showSimplified = false
    @StateObject var viewModel = OpenAIServicer()
    @State var showReader = false
    
    @StateObject var paperViewModel = PaperViewModel()

    
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
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .padding(.top, 34)
                    }
                    Spacer()
                        Button {
                            showReader.toggle()
                        } label: {
                            Text("Show Reader")
                        }
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .padding(.top, 34)

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
            SimpleTextView(openAI: viewModel, savedPaper: true, paper: paperViewModel.loadPaper(name: documentName)!)
        }
    }
}


struct DocumentPDFView: UIViewRepresentable {
    
  
    var pdfDocument: PDFDocument
    
    func makeUIView(context: Context) -> some UIView {
        let pdfView : PDFView = PDFView()
        
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
        pdfView.minScaleFactor = 0.5
        pdfView.maxScaleFactor = 5.0
    
        
        return pdfView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
