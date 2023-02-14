//
//  SavedPapersListView.swift
//  ResearchAI
//
//  Created by Sam Santos on 12/30/22.
//

import SwiftUI

struct SavedPaperListContainerView: View {
    
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
    
    static let storage = StorageManager()
    
    
    static var previews: some View {
        
        var sampleView = SavedPaperListContainerView()
        sampleView.listOfPapers = ["Paper 1", "Paper 2"]
        return NavigationView{
            sampleView.environmentObject(storage)
              
    
        }
    }
}
