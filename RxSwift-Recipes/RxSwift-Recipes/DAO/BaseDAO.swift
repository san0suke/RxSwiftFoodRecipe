//
//  BaseDAO.swift
//  RxSwift-Recipes
//
//  Created by Robson Cesar de Siqueira on 16/12/24.
//

import CoreData

class BaseDAO {
    
    // MARK: - Properties
    let context: NSManagedObjectContext

    // MARK: - Initialization
    init(context: NSManagedObjectContext = CoreDataManager.shared.persistentContainer.viewContext) {
        self.context = context
    }
    
    // MARK: - Delete
    func delete(_ object: NSManagedObject) -> Bool {
        context.delete(object)
        return saveContext()
    }
    
    func saveContext() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            print("Failed to update RecipeIngredient: \(error)")
            return false
        }
    }
}
