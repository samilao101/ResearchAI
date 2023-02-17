//
//  SavedPapersListView.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/30/22.
//

import SwiftUI
import PDFKit

struct SavedPaperListContainerView: View {
    
    @EnvironmentObject var storage: StorageManager
    @State var listOfPapers = [SavedPaper]()
    
    var body: some View {
       SavedPaperListView(listSavedPapers: listOfPapers)
        .onAppear {
            let papers = storage.listSavedPDFs()
            var savedPapers = [SavedPaper]()
            papers.forEach { paper in
                let pdf  = storage.load(withName: paper)!
                savedPapers.append(SavedPaper(title: paper, pdf: pdf))
            }
            listOfPapers = savedPapers
            
        
            
            
        }.navigationTitle("Saved Papers:")
    }
}



