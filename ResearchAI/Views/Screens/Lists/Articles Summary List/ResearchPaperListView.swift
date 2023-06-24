//
//  ContentView.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/28/22.
//

import SwiftUI
import PDFKit

struct ResearchPaperListView: View {
    
    @EnvironmentObject var appState : AppState 
    @StateObject var urlModel = SettingsModel.shared
    @State var textWriten = ""
    @State var showBrowser = false
    @State var showLocal = false
    @State var showLocalFileViewer = false
    @State var localPDF : PDFDocument? = nil
    @State var showLocalViewer = false
    
    var body: some View {
        
        VStack {
            HStack {
                TextField("Search Arxiv...", text: $textWriten)
                    .textViewModifier()
                Button("Send"){send(string: textWriten)}
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .tint(.black)
            }.padding(.horizontal)
            Divider().font(.largeTitle)
            if appState.noResults {
                Text("No Results...")
                Spacer()
            } else {
                List(appState.summaries) { summary in
                    NavigationLink(value: summary) {
                        ArticleRowView(title: summary.raiTitle, authors: summary.raiAuthors, publishedDate: summary.raiPublished)
                    }

                }

            }
            HStack {
                Button {
                    showBrowser.toggle()
                } label: {
                    HStack{
                        Image(systemName: "globe")
                        Text("Online")
                    }
                    .fullScreenCover(isPresented: $showBrowser) {
                        OnlinePaperViewer(paperManager: OnlinePaperManager(appState: appState), goBack: $showBrowser)
                    }
                    
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    showLocal.toggle()
                } label: {
                    HStack{
                        Image(systemName: "desktopcomputer")
                        Text("Local")
                    }
                    .fullScreenCover(isPresented: $showLocalFileViewer) {
                         LocalPDFPreView(appState: appState, goBack: $showLocalFileViewer, pdf: localPDF!)
                    }
                   
                }
                .buttonStyle(.borderedProminent)
                .fileImporter(isPresented: $showLocal, allowedContentTypes: [.pdf]) { result in
                    switch result {
                    case .success(let url):
                        if url.startAccessingSecurityScopedResource(), let pdf = try? NSData(contentsOfFile: url.path) as Data {
                                        localPDF = PDFDocument(data: pdf)
                                        showLocalFileViewer.toggle()
                                        url.stopAccessingSecurityScopedResource()
                                }
                    case .failure(_):
                        print("failed")
                    }
                }
            }

        }
        .navigationTitle("Research Papers:")
        .toolbar {
            
            if appState.savedComprehesions != nil {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SavedPaperAlbumView()
                            .environmentObject(appState)
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(style: .init(lineWidth: 2))
                            HStack{
                                Image(systemName: "newspaper")
                                    .foregroundColor(.red)
                                Text("Saved Articles")
                                    .bold()
                            }
                            .padding(3)
                        }
                    }

                }
            }
        }
      
        
    }
    func send(string: String) {
        Task { await appState.query(string) }
    }
}



struct ResearchPaperListView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationView {
            ResearchPaperListView()
                .environmentObject(AppState.shared)

        }
    }

}




