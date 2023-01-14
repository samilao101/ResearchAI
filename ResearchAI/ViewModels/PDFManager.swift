import Foundation
import PDFKit

class PDFManager: ObservableObject {
    static let shared = PDFManager()

    let fileManager = FileManager.default
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    @Published var savedDocument = false

    func save(pdf: PDFDocument, withName name: String, dataURL: URL)  {
        
         DispatchQueue.main.async  {
               
                    do {
                        let url = dataURL
                        let pdfData = try Data.init(contentsOf: url)
                        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                        let pdfNameFromUrl = "\(name).pdf"
                        let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                        try pdfData.write(to: actualPath, options: .atomic)
                        print("pdf successfully saved!")
                        self.savedDocument = true
                    } catch (let error) {
                        print("Pdf could not be saved")
                        print(error)
                        self.savedDocument = false
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
