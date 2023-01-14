//
//  SavedPapersListView.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/30/22.
//

import SwiftUI

struct SavedPapersListView: View {
    
    @EnvironmentObject var pdfManager: PDFManager
    @State var listOfPapers = [String]()
    
    var body: some View {
        VStack{
        List(listOfPapers, id:\.self){ paper in
            NavigationLink {
                DocumentPDFViewer(pdfDocument: pdfManager.load(withName: paper)!, documentName: paper.replacingOccurrences(of: ".pdf", with: ""))
            } label: {
                Text(paper)
            }

        }
        }
        .onAppear {
            listOfPapers = pdfManager.listSavedPDFs()
        }.navigationTitle("Saved Papers:")
    }
}

struct SavedPapersListView_Previews: PreviewProvider {
    static var previews: some View {
        SavedPapersListView()
    }
}
