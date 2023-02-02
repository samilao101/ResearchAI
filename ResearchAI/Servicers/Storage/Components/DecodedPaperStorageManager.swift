//
//  PaperViewModel.swift
//  ResearchAI
//
//  Created by Sam Santos on 1/8/23.
//

import Foundation
import CoreData

class DecodedPaperStorageManager: ObservableObject {
    @Published var paper: ParsedPaper?

    func loadPaper(name: String) -> ParsedPaper? {
        print("trying")
        if paper == nil {
            print("LOADING DATA")
            // get the document directory url
            let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

            // create the file url
            let paperUrl = documentsUrl.appendingPathComponent("\(name)")
    //        print(paperUrl)

            // use a JSON decoder to load the paper from the JSON file

            do {

                let data = try Data(contentsOf: paperUrl)
                
                if let jsonString = String(data: data, encoding: .utf8) {
                  print(jsonString)
                }
                let decoder = JSONDecoder()
                let loadedPaper = try decoder.decode(ParsedPaper.self, from: data)
                paper = loadedPaper
                return paper

            } catch (let error ) {
                print(error)
                return nil
            }
        }
        return paper
    }

    func savePaper(paperToSave: ParsedPaper, name:String) {
        // use a JSON encoder to convert the paper to a JSON file
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(paperToSave) {
            // get the document directory url
            let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

            // create the file url
            let fileUrl = documentsUrl.appendingPathComponent("\(name)")
            print(fileUrl)

            // write the JSON file to the File Manager
            try? data.write(to: fileUrl)

        } else {
            // handle error saving paper
            print("ERROR saving paper")
        }
    }
}


//class CorePaperViewModel: ObservableObject {
//    
//    private let context: NSManagedObjectContext
//    
//    init(context: NSManagedObjectContext) {
//        self.context = context
//    }
//    
//    func savePaper(_ paper: DecodedPaper, paperName: String) {
//        let entity = NSEntityDescription.insertNewObject(forEntityName: "PaperEntity", into: context)
//        
//        entity.setValue(paper.id.uuidString, forKey: "id")
//        entity.setValue(paper.title, forKey: "title")
//        
//        let sectionsData = try? JSONEncoder().encode(paper.sections)
//        entity.setValue(sectionsData, forKey: "sectionsData")
//        
//        try? context.save()
//    }
//    
//    func loadPaper(name: String) -> DecodedPaper? {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PaperEntity")
//        request.predicate = NSPredicate(format: "title == %@", name)
//        
//        guard let result = try? context.fetch(request),
//            let entity = result.first as? NSManagedObject,
//            let title = entity.value(forKey: "title") as? String,
//            let sectionsData = entity.value(forKey: "sectionsData") as? Data,
//            let sections = try? JSONDecoder().decode([DecodedPaper.Section].self, from: sectionsData)
//            else {
//                return nil
//        }
//        
//        return DecodedPaper(id: UUID(), title: title, sections: sections)
//    }
//}


