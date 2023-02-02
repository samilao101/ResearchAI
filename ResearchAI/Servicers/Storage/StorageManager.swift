import Foundation
import PDFKit

class StorageManager: ObservableObject {
    
    
     var pdfStorageManager = PDFStorageManager()
     var decodedPaperStorageManager = DecodedPaperStorageManager()
     var readingStorageManager = ReadingStorageManager()
    
    static let shared = StorageManager()

    let fileManager = FileManager.default
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @Published var savedDocument = false
    @Published var savedDocs : [Paper] = []
    
    func save(name: String, dataURL: URL, decodedPaper: ParsedPaper ) {
        
        pdfStorageManager.save(withName: name, pdfDataUrl: dataURL)
        decodedPaperStorageManager.savePaper(paperToSave: decodedPaper, name: name)
        readingStorageManager.addReadingEntity(id: name)
        
        savedDocument = true 
        
    }
    
    func load() {
        
        let listOfFileNames = pdfStorageManager.listSavedPDFs()
        
        listOfFileNames.forEach { pdfFileName in
        
            if let pdfFile = pdfStorageManager.load(withName: pdfFileName) {
                
                if let decodedFile = decodedPaperStorageManager.loadPaper(name: pdfFileName) {
                    
                    if let readingEntity = readingStorageManager.fetchEntity(id: pdfFileName) {
                        
                        let newRecord = Paper(paper: decodedFile, pdf: pdfFile, reading: readingEntity)
                        
                        savedDocs.append(newRecord)
                        
                    }
                    
                }
                
            }
                    
            
        }
        
        
    }
    
    

   

    func load(withName name: String) -> PDFDocument? {
        let fileURL = documentsDirectory.appendingPathComponent(name)
        if let pdf = PDFDocument(url: fileURL) {
            return pdf
        } else {
            return nil
        }
    }

    func listSavedPDFs() -> [String] {
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: documentsDirectory.path)
            let pdfs = contents.filter { $0.hasSuffix("pdf") }
            return pdfs
        } catch {
            print("Error listing saved PDFs: \(error)")
            return []
        }
    }
    
    func printHello() {
        print("hello")
    }
}
