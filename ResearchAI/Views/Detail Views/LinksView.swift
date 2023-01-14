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
    @EnvironmentObject var pdfManager: PDFManager
    
    let link: ResearchPaper.Link
    
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
            CustomPDFView(paperName: paperName, goBack: $showPDF, displayedPDFURL: URL(string:link.href.toHttps())!).environmentObject(pdfManager)
                .ignoresSafeArea()
        }
    }
    
    
}

