//
//  NSManagedObjectContext.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 16/12/24.
//

import CoreData

extension NSManagedObjectContext {
    
    func insertAndSave<T: NSManagedObject>(_ object: T) -> Bool {
        self.insert(object)
        return saveSafely()
    }
    
    func deleteAndSave<T: NSManagedObject>(_ object: T) -> Bool {
        self.delete(object)
        return saveSafely()
    }
    
    private func saveSafely() -> Bool {
        do {
            try self.save()
            return true
        } catch {
            print("Failed to save context: \(error)")
            return false
        }
    }
}
