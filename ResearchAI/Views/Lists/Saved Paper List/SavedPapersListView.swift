//
//  SavedPapersListView.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/30/22.
//

import SwiftUI

struct SavedPapersListView: View {
    
    @EnvironmentObject var storage: StorageManager
    @State var listOfPapers = [String]()
    
    var body: some View {
        VStack{
        List(listOfPapers, id:\.self){ paper in
            NavigationLink {
                SavedPaperPDFView(pdfDocument: storage.load(withName: paper)!, documentName: paper.replacingOccurrences(of: ".pdf", with: ""))
            } label: {
                Text(paper)
            }

        }
        }
        .onAppear {
            listOfPapers = storage.listSavedPDFs()
        }.navigationTitle("Saved Papers:")
    }
}

struct SavedPapersListView_Previews: PreviewProvider {
    static var previews: some View {
        SavedPapersListView()
    }
}
