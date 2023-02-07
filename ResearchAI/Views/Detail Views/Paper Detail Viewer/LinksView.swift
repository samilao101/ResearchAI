//
//  LinksView.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/29/22.
//

import SwiftUI

struct LinksView: View {
    
    let paperName: String
    @State var showPDF = false
    @EnvironmentObject var pdfManager: StorageManager
    
    let link: String
    
    var body: some View {

           
                Button {
                    showPDF.toggle()
                } label: {
                    HStack {
                        Image(systemName: "newspaper")
                        Text("PDF")
                    }
                }

            
            
        .fullScreenCover(isPresented: $showPDF) {
            ResearchPaperPDFView(paperName: paperName, goBack: $showPDF, displayedPDFURL: URL(string:link.toHttps())!).environmentObject(pdfManager)
                .ignoresSafeArea()
        }
    }
    
    
}

