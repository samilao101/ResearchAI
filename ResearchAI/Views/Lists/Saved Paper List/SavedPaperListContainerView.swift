//
//  SavedPapersListView.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/30/22.
//

import SwiftUI
import PDFKit

struct SavedPaperListContainerView: View {
    
    @State var listOfPapers = [Comprehension]()
    @EnvironmentObject var comprehensionLocalFileManager: LocalFileManager<Comprehension>
    
    var body: some View {
       SavedPaperListView(listSavedPapers: listOfPapers)
        .onAppear {

            if let comprehensions: [Comprehension] = comprehensionLocalFileManager.getAllModels() {
                comprehensions.forEach { comp in
                    print(comp.summary?.raiTitle)
                }
                self.listOfPapers = comprehensions

    
            }
            
        }.navigationTitle("Saved Papers:")
    }
}



