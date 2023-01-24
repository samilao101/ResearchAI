//
//  CoredataManager.swift
//  ResearchAI
//
//  Created by Sam Santos on 1/14/23.
//

import Foundation
import CoreData

class ReadingStorageManager: ObservableObject {
    
    let container: NSPersistentContainer
    let context : NSManagedObjectContext
    
    static let instance = ReadingStorageManager()
    
    @Published var readingEntities: [ReadingEntity] = []
    
    init() {
        
        container = NSPersistentContainer(name: "AppContainer")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error Loading Conatainer: \(error)")
            }
        }
        context = container.viewContext 
    }
    
    func fetchReadingEntities() {
        
        let request = NSFetchRequest<ReadingEntity>(entityName: "ReadingEntity")
        
        do {
            
        readingEntities = try context.fetch(request)
            
        } catch let error {
            print("Error Loading Entities: \(error)")
        }
        
    }
    
    func addReadingEntity(id: String, readingLocation: Int = 0, rate: Double = 1, pitch: Double = 1) {
        
        let newReadingEntity = ReadingEntity(context: context)
        newReadingEntity.id = id
        newReadingEntity.readingLocation = Int16(readingLocation)
        newReadingEntity.readingRate = rate
        newReadingEntity.readingPitch = pitch
        
        saveContainer()
        
    }
    
    func saveContainer() {
        
        do {
            
            try context.save()
            fetchReadingEntities()
            
        } catch let error {
            
            print("Error saving entities: \(error)")
            
        }
        
    }
    
    func fetchEntity(id: String) -> ReadingEntity? {
          let fetchRequest: NSFetchRequest<ReadingEntity> = ReadingEntity.fetchRequest()
          fetchRequest.predicate = NSPredicate(format: "id == %@", id)
          
          do {
              let entities = try context.fetch(fetchRequest)
              return entities.first
          } catch {
              print("Error fetching entity: \(error)")
              return nil
          }
      }
    
}
