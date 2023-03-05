//
//  PDFLoadingView.swift
//  ResearchAI
//
//  Created by Sam Santos on 3/3/23.
//

import SwiftUI

struct PDFLoadingView: View {
    
    let isPDFPresent: Bool
    let progress: Double
    @Binding var showPDF: Bool
    
    var body: some View {
        if isPDFPresent {
            VStack{
                ProgressView(value: progress)
                Text("Loading")
            }
        } else {
            Button {
                showPDF.toggle()
            } label: {
                HStack {
                    Image(systemName: "newspaper")
                    Text("PDF")
                }
            }
        }
    }
}

struct PDFLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        PDFLoadingView(isPDFPresent: true, progress: 0.5, showPDF: .constant(false))
    }
}
