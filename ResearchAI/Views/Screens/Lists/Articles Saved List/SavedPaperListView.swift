//
//  SavedPaperListView.swift
//  ResearchAI
//
//  Created by Sam Santos on 2/13/23.
//

import SwiftUI
import PDFKit

struct SavedPaper : Identifiable {
    let id = UUID()
    let title: String
    let pdf : PDFDocument
}


struct SavedPaperListView: View {
    
    var listSavedPapers : [Comprehension]
    
    var body: some View {
        VStack{
            List(listSavedPapers) { paper in
                NavigationLink {
                    SavedPaperPDFView(pdfDocument: paper.pdfDocument!, documentName: paper.summary?.raiTitle ?? "No Title", paper: paper.decodedPaper!)
                } label: {
                    HStack{
                        Text(paper.summary!.raiTitle)
                        Spacer()
                        if let image = generatePdfThumbnail(for: paper.pdfDocument!) {
                            Image(uiImage: image)
                                .border(Color.black, width: 2)
                                .cornerRadius(3)
                        }
                    }
                }
                
                
            }
            
        }.navigationTitle("Saved Papers:")
    }
    
    func generatePdfThumbnail(of thumbnailSize: CGSize = CGSize(width: 200, height: 200) , for pdfDoc: PDFDocument, atPage pageIndex: Int = 0) -> UIImage? {
        
        let pdfDocumentPage = pdfDoc.page(at: pageIndex)
        return pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox)
    }
    
    
}

#if DEBUG
let pdfPath = Bundle.main.path(forResource: "researchpaper1", ofType: "pdf")
let pdfUrl = URL(fileURLWithPath: pdfPath!)
let pdfData = try! Data(contentsOf: pdfUrl)
let pdf = PDFDocument(data: pdfData)!
#endif


//struct SavedPaperListView_Previews: PreviewProvider {
//
//    
//    static let papers: [SavedPaper] =
//   [SavedPaper(title: "Machine Learning", pdf: pdf)]
//    
//    static var previews: some View {
//        NavigationView{
//            SavedPaperListView(listSavedPapers: papers)
//        }
//    }
//    
//  
//}
