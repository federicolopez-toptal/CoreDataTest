//
//  TextsManager.swift
//  TestDemo
//
//  Created by Federico Lopez on 01/09/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit
import CoreData

enum DataProviderError: Error {
    case CANT_FETCH
    case CANT_WRITE
}



class DataProvider: NSObject {
    
    // MARK: - Read
    func getAllEntries(callback: ([String]?) ->() ) {
        let managedContext = getManagedContext()!
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: ENTITY_ENTRY)
        let sortByContent = NSSortDescriptor(key:CONTENT_FIELD, ascending:true)
        fetchRequest.sortDescriptors = [sortByContent]
        
        var result: [String] = []
        do {
            let entries = try managedContext.fetch(fetchRequest)
            result = buildArray(input: entries)
            callback(result)
        } catch {
            callback(nil)
        }
    }
    
    private func buildArray(input: [NSManagedObject]) -> [String] {
        var result: [String] = []
        
        for obj in input {
            let content = obj.value(forKey: CONTENT_FIELD) as! String
            result.append(content)
        }
        
        return result
    }
    
    private func getEntryWithText(_ text: String, callback: (NSManagedObject?) -> ()) {
        let managedContext = getManagedContext()!
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: ENTITY_ENTRY)
        
        let predicate = NSPredicate(format: "content = [c] %@", text)
        fetchRequest.predicate = predicate
        
        do {
            let entries = try managedContext.fetch(fetchRequest)
            if(entries.count>0) {
                callback(entries.first)
            } else {
                callback(nil)
            }
        } catch {
            callback(nil)
        }
    }
    
    
    // MARK: - Write
    func addNewEntry(_ text: String, callback: (Bool, Bool) -> () ) {
        getEntryWithText(text) { (obj) in
            if(obj == nil) {
                let managedContext = getManagedContext()!
                let entity = NSEntityDescription.entity(forEntityName: ENTITY_ENTRY, in: managedContext)!
                
                let newEntry = NSManagedObject(entity: entity, insertInto: managedContext)
                newEntry.setValue(text, forKeyPath: CONTENT_FIELD)
                
                do {
                    try managedContext.save()
                    callback(true, false)
                } catch {
                    callback(false, false)
                }
            } else {
                callback(false, true)
            }
        }
    }
    
    func removeEntryWithText(_ text: String, callback: (Bool) -> () ) {
        getEntryWithText(text) { (obj) in
            if let entry = obj {
                let managedContext = getManagedContext()!
                managedContext.delete( entry )
                
                do {
                    try managedContext.save()
                    callback(true)
                } catch {
                    print("Error deleting object")
                    callback(false)
                }
            }
        }
    }
    
    
    // MARK: - misc
    private func getManagedContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
}
