//
//  ConversationStorage.swift
//  ResearchAI
//
//  Created by Sam Santos on 5/12/23.
//

import Foundation
import CoreData

class ConversationStorage: ObservableObject {
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    static let instance = ConversationStorage()
    
    
    @Published var conversations: [Conversation] = []
    
    init() {
        container = NSPersistentContainer(name: "AppContainer")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading container: \(error)")
            }
        }
        
        context = container.viewContext
        fetchConversations()
    }
    
    func saveContainer() {
        
        do {
            
            try context.save()
            fetchConversations()
            
        } catch let error {
            
            print("Error saving entities: \(error)")
            
        }
        
    }
    
    func fetchConversations() {
        
        let request = NSFetchRequest<Conversation>(entityName: "Conversation")
        
        do {
            
        conversations = try context.fetch(request)
            
        } catch let error {
            print("Error Loading Entities: \(error)")
        }
        
    }
    
    func saveConversation(paperID: String, paragraph: Int, source: String, message: String) {
        
        let newConversation = Conversation(context: context)
        newConversation.paperID = paperID
        newConversation.paragraph = Int16(paragraph)
        newConversation.source = source
        newConversation.message = message
        newConversation.timestamp = Date()
        
        saveContainer()
    }
    
    func getSimplification(paperID: String, par: Int) -> String? {
        
        return conversations.first { conv in
            conv.paperID == paperID && conv.paragraph == par
        }?.message
        
    }
    
    func getMessages(id: String, par: Int) -> [Conversation] {
        
        print(conversations)
        
        var convos = conversations.filter { conv in
            conv.paperID == id && conv.paragraph == par
        }.sorted { conv1, conv2 in
            conv1.timestamp! < conv2.timestamp!
        }
        convos.removeFirst()
        
        return convos
        
    }
    
    
    func getMessagesWithFirst(id: String, par: Int) -> [Conversation] {
        
        print(conversations)
        
        var convos = conversations.filter { conv in
            conv.paperID == id && conv.paragraph == par
        }.sorted { conv1, conv2 in
            conv2.timestamp! < conv1.timestamp!
        }
        
        return convos
        
    }

    
    
}
