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
    
    @EnvironmentObject var appState : AppState

    var body: some View {
        VStack{
            List(appState.savedComprehesions!) { paper in
                NavigationLink {
                    SavedPaperPDFView(pdfDocument:PDFDocument(data:paper.pdfData!)!, comprehension: paper)
                        .environmentObject(appState)
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


struct SavedPaperAlbumView: View {
    
    @EnvironmentObject var appState : AppState
    
    func getPercentage(geo: GeometryProxy) -> Double {
        let maxD = UIScreen.main.bounds.width / 2
        let current = geo.frame(in: .global).midX
        return Double(1 - (current/maxD))
    }
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                ForEach(appState.savedComprehesions!, id:\.self) { paper in
                    GeometryReader { geo in
                        NavigationLink {
                            SavedPaperPDFView(pdfDocument:PDFDocument(data:paper.pdfData!)!, comprehension: paper)
                                .environmentObject(appState)
                        } label: {
                            VStack(alignment: .trailing) {
                                Spacer()
                                Text(paper.summary!.raiTitle)
                                    .multilineTextAlignment(.center)
                                    .font(.system(.subheadline, design: .rounded)).bold()
                                    .foregroundColor(.black)
                                if let image = generatePdfThumbnail(for: paper.pdfDocument!) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .border(Color.black, width: 2)
                                        .cornerRadius(3)
                                }
                              Spacer()
                              Spacer()
                            }
                            .rotation3DEffect(Angle(degrees: getPercentage(geo: geo) * 30.0), axis: (x: 0.0, y: 1.0, z: 0.0))
                            .scaleEffect(1.25)
                            .padding(.top, 16 )
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.70, height: UIScreen.main.bounds.height*0.90)
                    .padding()
                }
            }
        }.navigationTitle("Saved Articles:")
        
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
