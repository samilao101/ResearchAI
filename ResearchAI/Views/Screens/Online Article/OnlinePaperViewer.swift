//
//  OnlinePaperViewer.swift
//  ResearchAI
//
//  Created by Sam Santos on 5/18/23.
//

import SwiftUI
import PDFKit


struct OnlinePaperViewer: View, PaperViewProtocol {
    
    @StateObject var paperDecoder = PaperDecoder()
    var paperManager: PaperManagerProtocol
    @State var pdf: PDFDocument?
    @State private var webView: WebView?
    @State var localPaperURL: URL? = nil
    @Binding var goBack: Bool
    @State var urlString = ""
    @State var showReader = false



    var body: some View {
        ZStack {
            if webView != nil {
                ZStack {
                    VStack{
                        ZStack{
                            webView
                            VStack {
                                HStack{
                                    backButton
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        HStack {
                            HStack {
                                TextField("Enter Link to PDF....", text: $urlString)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .autocorrectionDisabled(true)
                                    .textInputAutocapitalization(.never)
                                Button(action: {
                                   
                                    navigateTo(urlString: urlString)
                                    
                                }, label: {Image(systemName: "arrow.right.circle")})
                            }
                            .padding()
                            .background(.thinMaterial)
                            Spacer()
                        }
                    }
                    if localPaperURL != nil {
                        if paperDecoder.gotPaper {
                            VStack {
                                Spacer()
                                HStack{
                                    readerButton
                                        .onAppear {
                                            
                                            print("Decoded Paper")
                                            print(paperDecoder.summary)
                    
                                            paperManager.appState.comprehension.decodedPaper = paperDecoder.paper
                                            
                                            paperManager.appState.comprehension.summary
                                            = paperDecoder.summary
                                        }
                                    Spacer()
                                }
                                .padding(.bottom, 44)
                            }
                        } else {
                            VStack {
                                Spacer()
                                HStack{
                                    loadingView
                                    Spacer()
                                }
                                .padding(.bottom, 44)
                            }
                        }
                    }
                }
            } else {
                Text("Loading")
                    .onAppear {
                        webView = WebView(action: { url in
                            if let url = url {
                                loadPaper(url: url)
                            }
                        })
                    }
            }
        }
        .fullScreenCover(isPresented: $showReader, content: {

            AudioPlayerView(readerViewModel: ReaderViewModel(comprehension: paperManager.appState.comprehension, savedPaper: false), goBack: $showReader)
            
        })
    }


    func loadPaper(url: URL) {
        do {
            let pdfData = try Data(contentsOf: url)
            localPaperURL = url
            paperDecoder.sendPDF(pdfFileURL: url)
            paperManager.appState.comprehension.pdfData = pdfData
            
        } catch(let error) {
            print(error)
        }
        
    }


    func fetchPaper() async {

    }
    
    func navigateTo(urlString: String){
        
        localPaperURL = nil
        paperDecoder.gotPaper = false
        
        if urlString.hasSuffix(".com") {
            
            if urlString.hasPrefix("https://") {
                webView?.loadUrl(urlString)
            } else {
                let goodString = "https://" + urlString
                webView?.loadUrl(goodString)
            }
        } else {
                let goodString  = "https://www.google.com/search?q=" + urlString
                webView?.loadUrl(goodString)
            
        }
    }
}


extension OnlinePaperViewer {
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
//struct OnlinePaperViewer: View, PaperViewProtocol {
//    var paperManager: PaperManagerProtocol
//    var pdf: PDFDocument?
//
//
//
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//
//
//
//            .task {
//                await fetchPaper()
//            }
//    }
//
//
//
//
//    func fetchPaper() async {
//
//    }
//}

//struct OnlinePaperViewer_Previews: PreviewProvider {
//    static var previews: some View {
//        OnlinePaperViewer()
//    }
//}
 
