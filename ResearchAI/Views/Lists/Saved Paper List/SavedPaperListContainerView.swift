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
    @State var listOfPapers = [Comprehension]()
    @EnvironmentObject var comprehensionLocalFileManager: LocalFileManager<Comprehension>
    
    var body: some View {
       SavedPaperListView(listSavedPapers: listOfPapers)
        .onAppear {
//            let papers = storage.listSavedPDFs()
//            var savedPapers = [SavedPaper]()
//            papers.forEach { paper in
//                let pdf  = storage.load(withName: paper)!
//                savedPapers.append(SavedPaper(title: paper, pdf: pdf))
//            }
//            self.listOfPapers = savedPapers
            
        
            if let comprehensions: [Comprehension] = comprehensionLocalFileManager.getAllModels() {
                comprehensions.forEach { comp in
                    print(comp.summary?.raiTitle)
                }
                self.listOfPapers = comprehensions

    
            }
            
        }.navigationTitle("Saved Papers:")
    }
}



