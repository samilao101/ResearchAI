//
//  SavedPaperListView.swift
//  ResearchAI
//
//  Created by Sam Santos on 2/13/23.
//

import SwiftUI
import PDFKit
//
//struct SavedPaper : Identifiable {
//    let id = UUID()
//    let title: String
//    let pdf : PDFDocument
//}




struct SavedPaperAlbumView: View {

    @EnvironmentObject var appState: AppState
    @State var showReader = false
    @State var paper: Comprehension? = nil
    let persistenceController = PersistenceController.shared
    @State private var searchTerm = ""
    var filteredComprehensions: [Comprehension]? {
        guard !searchTerm.isEmpty else { return appState.savedComprehesions }
        return appState.savedComprehesions?.filter({ $0.summary!.raiTitle.localizedStandardContains(searchTerm) }) ?? []
    }
    @State var editMode = false

    var body: some View {
        NavigationStack{
            ScrollView {
              
                    ForEach(filteredComprehensions ?? [], id: \.self) { doc in
                        VStack(alignment: .trailing) {
                            ZStack{
                                SavedPaperCellView(
                                    title: doc.summary?.raiTitle ?? "",
                                    icon: generatePdfThumbnail(for: doc.pdfDocument) ?? UIImage(),
                                    authors: doc.summary?.raiAuthors ?? [""],
                                    publishedDate: doc.summary?.raiPublished ?? "Uknown", id: doc.decodedPaper!.id.uuidString
                                )
                                if editMode {
                                    Button {
                                        removeItem(id: doc.id.uuidString)

                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(.gray.opacity(0.4))
                                            Image(systemName: "trash")
                                                .font(.largeTitle)
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                            }
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                            .padding()
                        }
                        .onTapGesture {
                            self.paper = doc
                            showReader.toggle()
                        }
                        if paper != nil {
                           EmptyView()
                        }
                
                }
                
                .navigationTitle("Saved Articles:")
                .searchable(text: $searchTerm, placement: .automatic, prompt: "Search titles...")
                
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            editMode.toggle()
                        } label: {
                            if editMode {
                                Text("Done")
                            } else {
                                Text("Edit")
                            }
                        }

                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showReader) {
            if let paper = paper {
                AudioPlayerView(
                    readerViewModel: ReaderViewModel(
                        comprehension: paper, // Provide default value or make ReaderViewModel handle nil values
                        savedPaper: true),
                    goBack: $showReader
                )
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

            } else {
                EmptyView()
            }
        }
        
    }

    func generatePdfThumbnail(of thumbnailSize: CGSize = CGSize(width: 200, height: 200), for pdfDoc: PDFDocument?, atPage pageIndex: Int = 0) -> UIImage? {
        guard let pdfDocumentPage = pdfDoc?.page(at: pageIndex) else {
            return nil
        }
        return pdfDocumentPage.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox)
    }
    
    func removeItem(id: String ){
        appState.removeComprehensionFromStorage(id: id)
    }
}


#if DEBUG
let pdfPath = Bundle.main.path(forResource: "researchpaper1", ofType: "pdf")
let pdfUrl = URL(fileURLWithPath: pdfPath!)
let pdfData = try! Data(contentsOf: pdfUrl)
let pdf = PDFDocument(data: pdfData)!

func generatePdfThumbnail(of thumbnailSize: CGSize = CGSize(width: 200, height: 200) , for pdfDoc: PDFDocument, atPage pageIndex: Int = 0) -> UIImage? {

    let pdfDocumentPage = pdfDoc.page(at: pageIndex)
    return pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox)
}

let thumbnail = generatePdfThumbnail(for: pdf)
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

//
//struct SavedPaperListView: View {
//
//    @EnvironmentObject var appState : AppState
//
//    var body: some View {
//        VStack{
//            List(appState.savedComprehesions!) { paper in
//                NavigationLink {
//                    SavedPaperPDFView(pdfDocument:PDFDocument(data:paper.pdfData!)!, comprehension: paper)
//                        .environmentObject(appState)
//                } label: {
//                    HStack{
//                        Text(paper.summary!.raiTitle)
//                        Spacer()
//                        if let image = generatePdfThumbnail(for: paper.pdfDocument!) {
//                            Image(uiImage: image)
//                                .border(Color.black, width: 2)
//                                .cornerRadius(3)
//                        }
//                    }
//                }
//            }
//
//        }.navigationTitle("Saved Papers:")
//    }
//
//    func generatePdfThumbnail(of thumbnailSize: CGSize = CGSize(width: 200, height: 200) , for pdfDoc: PDFDocument, atPage pageIndex: Int = 0) -> UIImage? {
//
//        let pdfDocumentPage = pdfDoc.page(at: pageIndex)
//        return pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox)
//    }
//
//
//}



//struct SavedPaper : Identifiable {
//    let id = UUID()
//    let title: String
//    let pdf : PDFDocument
//}
