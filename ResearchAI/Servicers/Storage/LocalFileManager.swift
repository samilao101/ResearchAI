//
//  LocalFileManager.swift
//  ResearchAI
//
//  Created by Sam Santos on 2/18/23.
//

import Foundation


class LocalFileManager<T: Codable>: ObservableObject {
        
    let folder: Constant.Folders
    
    let model: T.Type

    init(folder: Constant.Folders, model: T.Type) {
        self.folder = folder
        self.model = model
        createFolderIfNeeded()
    }
    
    @Published var savedDocument = false
    
    func createFolderIfNeeded() {
        
        guard let path = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folder.rawValue)
            .path else {return}
        
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
                print("Success Creating Folder")
            } catch let error {
                print("error creating folder: \(error.localizedDescription)")
            }
        }
        
    }

    
    func saveModel(object: T, id: String) {
        
        
        let encoder = JSONEncoder()
        
        let encodedModel  = try? encoder.encode(object)
        
        guard let data = encodedModel, let path = getPathForModel(id: id) else
        { print("issue encoding")
            return }
        
        do {
            try data.write(to: path)
            self.savedDocument = true
            print("Success Saving!")
        } catch let error {
            print(error.localizedDescription)
        }
        

    }
    
    func getModel(id: String) -> T? {
        
        guard let path = getPathForModel(id: id), FileManager.default.fileExists(atPath: path.path)
        else {
            print("Error Getting path")
            return nil}

        let decoder = JSONDecoder()
        
        guard let data = try? Data(contentsOf: path) else {
            print("error getting data")
            return nil}
        
        guard let decodedModel = try? decoder.decode(T.self, from: data ) else {
            print("error decoding")
            return nil}
        
        return decodedModel
        
    }
    
    func getPathForModel(id: String) -> URL? {
        
        guard let path = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folder.rawValue)
            .appendingPathComponent(id)
        else {return nil}
        
        return path
        
    }
    
    func deleteModel(id: String) {
        
        guard let path = getPathForModel(id: id), FileManager.default.fileExists(atPath: path.path)
        else {
            print("Error Getting path")
            return}
      
        do {
            try FileManager.default.removeItem(at: path)
            print("successfully deleted")
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    
    func getAllModels() -> [T]? {
        
        var documents: [T] = [T]()
        
        guard let path = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folder.rawValue)
            .path else {return nil}
        
        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: path) else { return nil }
        
        let decoder = JSONDecoder()

        contents.forEach { content in
            
            guard let path = getPathForModel(id: content) else { return }
    
            guard let data = try? Data(contentsOf: path) else {
                print("error getting data")
                return}
            
            guard let decodedModel = try? decoder.decode(T.self, from: data ) else {
                print("error decoding")
                return}
            
            documents.append(decodedModel)
        }
        
        if documents.isEmpty {
            return nil
        } else {
            return documents
        }
        
    }
    
    
}
