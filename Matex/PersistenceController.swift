//
//  PersistenceController.swift
//  Matex
//
//  Created by Sahil Sharma on 05/04/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "MatexDataModel")
        container.loadPersistentStores(completionHandler: {description, error in
            if let error = error {
                fatalError("Error Loading Persistence Store: \(error.localizedDescription)")
            }
            
        })
    }
    
    func save(completion: @escaping (Error?) -> () = {_ in}){
        let context = container.viewContext
        if context.hasChanges{
            do{
                try context.save()
                completion(nil)
            }
            catch{
                completion(error)
            }
        }
    }
    
    func delete(delete object: NSManagedObject, completion: @escaping (Error?) -> () = {_ in}){
        let context = container.viewContext
        context.delete(object)
        save(completion: completion)
    }
}
